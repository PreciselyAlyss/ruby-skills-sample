require 'dotenv'
require 'openssl'
require 'sinatra'
require 'clarinet'
require 'ostruct'

# Load config environment variables
Dotenv.load('./.env')

# Receive JSON from webhook POST
# URL: https://sendgrid.com/blog/simple-webhook-testing-using-sinatra-ngrok/
post '/' do
  # Successful request
  status 200 

  # Parse webhook payload
  request.body.rewind
  request_payload = JSON.parse(request.body.read, object_class: OpenStruct)
  file_id = request_payload['source']['id']
  write_token = request_payload['token']['write']['access_token']
  read_token = request_payload['token']['read']['access_token']
  template = 'boxSkillsCards'

  # Shared link with access token
  file_url = "https://api.box.com/2.0/files/#{file_id}/content?access_token=#{read_token}"
  update_url = URI("https://api.box.com/2.0/files/#{file_id}/metadata/global/#{template}")

  # Clarifai ruby client
  clar_client = Clarinet::App.new(ENV['CLARIFAI_SECRET'])
  clar_response = clar_client.models.predict(Clarinet::Model::GENERAL, file_url)

  # http://billpatrianakos.me/blog/2013/09/29/rails-tricky-error-no-implicit-conversion-from-symbol-to-integer/
  # currently not functioning, type error due to hash being interpreted as array
  clar_response[:outputs][:data][:concepts][:name].each do |concept|
    entries << {type: 'text', text: concept}
  end

  # Format metadata with date in ISO string format
  metadata = {cards: [{
      created_at: Time.now.strftime('%Y-%m-%dT%H:%M:%S.%L%z'),
      type: 'skill_card',
      skill_card_type: 'keyword',
      skill_card_title: {
        message: 'Categories'
      },
      skill: {
        type: 'service',
        id: 'alyss-clarifai'
      },
      invocation: {
        type: 'skill_invocation',
        id: file_id
      },
      entries: entries
    }]
  }.to_json

  # Post request with metadata to Box
  res = HTTParty.post(update_url, 
    :body => metadata,
    :headers => { 'Authorization' => "Bearer #{write_token}",
    'Content-Type' => 'application/json'})
 
  # Check if request successful 
  if res.code == 200 || 201
    puts "Success!"
    puts res.read_body
    puts res.message
  else 
    puts "Something went wrong."
    puts res.code
    puts res.read_body
    puts res.message
  end
end

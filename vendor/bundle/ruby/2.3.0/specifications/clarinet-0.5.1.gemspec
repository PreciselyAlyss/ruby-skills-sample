# -*- encoding: utf-8 -*-
# stub: clarinet 0.5.1 ruby lib

Gem::Specification.new do |s|
  s.name = "clarinet".freeze
  s.version = "0.5.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Jaakko Rinta-Filppula".freeze]
  s.date = "2018-02-11"
  s.description = "Simple client to interface with the Clarifai API v2".freeze
  s.email = "jaakko.rf@gmail.com".freeze
  s.homepage = "https://github.com/tophattom/clarinet".freeze
  s.licenses = ["ISC".freeze]
  s.rubygems_version = "2.5.2.3".freeze
  s.summary = "Clarifai API client".freeze

  s.installed_by_version = "2.5.2.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<httparty>.freeze, ["~> 0.14"])
      s.add_runtime_dependency(%q<addressable>.freeze, ["~> 2.5"])
    else
      s.add_dependency(%q<httparty>.freeze, ["~> 0.14"])
      s.add_dependency(%q<addressable>.freeze, ["~> 2.5"])
    end
  else
    s.add_dependency(%q<httparty>.freeze, ["~> 0.14"])
    s.add_dependency(%q<addressable>.freeze, ["~> 2.5"])
  end
end

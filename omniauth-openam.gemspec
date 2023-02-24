# -*- encoding: utf-8 -*-
require File.expand_path('../lib/omniauth-openam/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors = ["Rahul Ghose"]
  gem.email = ["rahul.gh@directi.com"]
  gem.description = "This is an OmniAuth provider for OpenAM's REST API"
  gem.summary = "An OmniAuth provider for OpenAM REST API"
  gem.homepage = "http://tree.mn/rghose/omniauth-openam"

  gem.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files = `git ls-files`.split("\n")
  gem.name = "omniauth-openam"
  gem.require_paths = ["lib"]
  gem.version = OmniAuth::Openam::VERSION

  gem.add_dependency 'omniauth', '>= 1', '< 3'
  gem.add_dependency 'nokogiri', '>= 1.4.4'
end

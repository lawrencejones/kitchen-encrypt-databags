# coding: utf-8
# frozen_string_literal: true
Gem::Specification.new do |gem|
  gem.name          = "kitchen-encrypt-databags"
  gem.version       = "0.2.0"
  gem.summary       = "automatically encrypt databags when provisioning sandbox"
  gem.description   = "test-kitchen add-on"
  gem.authors       = ["Lawrence Jones"]
  gem.homepage      = "https://github.com/lawrencejones/kitchen-encrypt-databags"
  gem.email         = %w(lawrjone@gmail.com)
  gem.license       = "MIT"

  gem.files         = Dir["lib/**/*.rb"]
  gem.test_files    = gem.files.grep(%r{^spec/})
  gem.require_paths = ["lib"]

  gem.add_dependency "chef",         ">= 12.10"
  gem.add_dependency "test-kitchen", "~> 1.13"
end

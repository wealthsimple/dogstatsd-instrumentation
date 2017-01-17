# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("../lib", __FILE__)
require "dogstatsd/instrumentation/identity"

Gem::Specification.new do |spec|
  spec.name = DogStatsd::Instrumentation::Identity.name
  spec.version = DogStatsd::Instrumentation::Identity.version
  spec.platform = Gem::Platform::RUBY
  spec.authors = ["Marco Costa"]
  spec.email = ["marco@marcotc.com"]
  spec.homepage = "https://github.com/wealthsimple/dogstatsd-instrumentation"
  spec.summary = 'Reports instrumention metrics from various Ruby web frameworks to Datadog.'
  spec.description = 'This gem processes relevant ActiveSupport::Notifications for Rails, Sinatra and Rake applications, sending metrics to Datadog.'
  spec.license = "MIT"

  if File.exist?(Gem.default_key_path) && File.exist?(Gem.default_cert_path)
    spec.signing_key = Gem.default_key_path
    spec.cert_chain = [Gem.default_cert_path]
  end

  spec.add_dependency 'dogstatsd-ruby', "~> 2"
  spec.add_runtime_dependency 'gem_config', '~> 0'

  spec.add_development_dependency "rake", "~> 11.0"
  spec.add_development_dependency "gemsmith", "~> 8.1"
  spec.add_development_dependency "pry", "~> 0.10"
  spec.add_development_dependency "pry-byebug", "~> 3.4"
  spec.add_development_dependency "pry-state", "~> 0.1"
  spec.add_development_dependency "rspec", "~> 3.5"
  spec.add_development_dependency "guard-rspec", "~> 4.7"
  spec.add_development_dependency "reek", "~> 4.5"
  spec.add_development_dependency "rubocop", "~> 0.45"

  spec.files = Dir["lib/**/*"]
  spec.extra_rdoc_files = Dir["README*", "LICENSE*"]
  spec.require_paths = ["lib"]
end

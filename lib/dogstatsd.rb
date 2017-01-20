# frozen_string_literal true

require 'active_support'
require 'gem_config'
require 'datadog/statsd'
require_relative 'dogstatsd/instrumentation/client_provider'

module DogStatsd
  PUBLIC_METHODS = %w(increment decrement count gauge histogram timing time set service_check format_service_check event batch format_event).freeze
  
  class << self
    extend Forwardable

    def_delegators :statsd, *PUBLIC_METHODS

    def statsd
      Thread.current[:_dogstatsd_instrumentation_client] ||= Instrumentation::ClientProvider.new
    end
  end
end

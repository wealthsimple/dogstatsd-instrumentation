# frozen_string_literal: true

require 'active_support'
require 'gem_config'
require 'datadog/statsd'

module DogStatsd
  module Instrumentation
    module ClientProvider
      include GemConfig::Base

      with_configuration do
        has :enabled, classes: [TrueClass, FalseClass], default: true
        has :tags, classes: Array, default: []
        has :tags_h, classes: Hash, default: {}
        has :namespace, classes: String

        has :host, classes: String, default: Datadog::Statsd::DEFAULT_HOST
        has :port, classes: Integer, default: Datadog::Statsd::DEFAULT_PORT
        has :opts, classes: Hash, default: {}
        has :max_buffer_size, classes: Integer, default: 50
      end

      def self.new
        client = Datadog::Statsd.new(
          configuration.host,
          configuration.port,
          configuration.opts.merge(namespace: configuration.namespace, tags: configuration.tags + tagify(configuration.tags_h)),
          configuration.max_buffer_size
        )

        def client.send_stats(stat, delta, type, opts={})
          super if ClientProvider.configuration.enabled
        end

        client
      end

      def self.tagify(hash)
        hash.select { |_, value| value.present? }.map { |key, value| "#{key}:#{value}" }
      end
    end
  end
end

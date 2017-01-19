# frozen_string_literal: true

require 'active_support'
require 'gem_config'
require 'datadog/statsd'

module DogStatsd
  module Instrumentation
    module Request
      include GemConfig::Base

      with_configuration do
        has :enabled, classes: [TrueClass, FalseClass], default: true
        has :base_tags, classes: Hash, default: {}

        has :host, classes: String, default: Datadog::Statsd::DEFAULT_HOST
        has :port, classes: Integer, default: Datadog::Statsd::DEFAULT_PORT
        has :opts, classes: Hash, default: {}
        has :max_buffer_size, classes: Integer, default: 50
      end

      # From GemConfig::Base
      def self.configure
        super
        @@subscriber = @@subscriber.unsubscribe if @@subscriber
        @@subscriber = Subscriber.new(configuration) if configuration.enabled
      end

      @@subscriber = nil

      class Subscriber
        def initialize(configuration)
          @base_tags = configuration.base_tags

          @statsd = Datadog::Statsd.new(
            configuration.host,
            configuration.port,
            configuration.opts,
            configuration.max_buffer_size
          )

          @subscriber = ActiveSupport::Notifications.subscribe /process_action.action_controller/ do |*args|
            event = ActiveSupport::Notifications::Event.new(*args)
            tags = {
              controller: event.payload[:controller],
              method: event.payload[:method],
              status: event.payload[:status],
            }

            tags[:action] = "#{tags[:controller]}##{event.payload[:action]}" if event.payload[:action]

            instrument stat: 'process_action.action_controller.duration', value: event.duration, tags: tags

            event.payload.select { |key, _| key.to_s.end_with? '_runtime' }.each do |name, duration|
              instrument stat: "process_action.action_controller.#{name}", value: duration, tags: tags
            end
          end
        end

        def instrument(stat:, value:, tags:)
          @statsd.histogram stat, value, tags: Subscriber.tagify(@base_tags.merge(tags))
        end

        def self.tagify(hash)
          hash.select { |_, value| value.present? }.map { |key, value| "#{key}:#{value}" }
        end

        def unsubscribe
          ActiveSupport::Notifications.unsubscribe @subscriber
          nil
        end
      end
    end
  end
end

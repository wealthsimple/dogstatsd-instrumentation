# frozen_string_literal: true

require 'active_support'
require 'gem_config'
require 'datadog/statsd'
require_relative 'client_provider'

module DogStatsd
  module Instrumentation
    module Request
      include GemConfig::Base

      with_configuration do
        has :statsd, classes: Object
      end

      # From GemConfig::Base
      def self.configure
        super
        @@subscriber.unsubscribe if @@subscriber

        @@subscriber = Subscriber.new(configuration.statsd || ClientProvider.new)
      end

      @@subscriber = nil

      class Subscriber
        def initialize(statsd)
          @statsd = statsd

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
          @statsd.histogram stat, value, tags: Subscriber.tagify(tags)
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

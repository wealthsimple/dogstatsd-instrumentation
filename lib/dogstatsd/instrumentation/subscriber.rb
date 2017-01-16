# frozen_string_literal: true

require 'active_support'
require 'datadoge/version'
require 'gem_config'
require 'datadog/statsd'

module Dogstatsd
  module Instrumentation
    # Gem identity information.
      include GemConfig::Base

      with_configuration do
        has :environments, classes: Array, default: ['production']
        has :host, classes: String, default: Datadog::Statsd::DEFAULT_HOST
        has :port, classes: Integer, default: Datadog::Statsd::DEFAULT_PORT
        has :opts, classes: Hash, default: {}
        has :max_buffer_size, classes: Integer, default: 50
      end

      def install
        initializer "datadoge.configure_rails_initialization" do |app|
          $statsd = Datadog::Statsd.new(
            Datadoge.configuration.host,
            Datadoge.configuration.port,
            Datadoge.configuration.opts,
            Datadoge.configuration.max_buffer_size
          )

          ActiveSupport::Notifications.subscribe /process_action.action_controller/ do |*args|
            event = ActiveSupport::Notifications::Event.new(*args)
            controller = "controller:#{event.payload[:controller]}"
            action = "action:#{event.payload[:action]}"
            format = "format:#{event.payload[:format] || 'all'}"
            format = "format:all" if format == "format:*/*"

            status = event.payload[:status]
            tags = [controller, action, format]
            ActiveSupport::Notifications.instrument :performance, :action => :timing, :tags => tags, :measurement => "request.total_duration", :value => event.duration
            ActiveSupport::Notifications.instrument :performance, :action => :timing, :tags => tags, :measurement => "database.query.time", :value => event.payload[:db_runtime]
            ActiveSupport::Notifications.instrument :performance, :action => :timing, :tags => tags, :measurement => "web.view.time", :value => event.payload[:view_runtime]
            ActiveSupport::Notifications.instrument :performance, :tags => tags, :measurement => "request.status.#{status}"
          end

          ActiveSupport::Notifications.subscribe /performance/ do |name, start, finish, id, payload|
            send_event_to_statsd(name, payload) if Datadoge.configuration.environments.include?(Rails.env)
          end

          def send_event_to_statsd(name, payload)
            action = payload[:action] || :increment
            measurement = payload[:measurement]
            value = payload[:value]
            tags = payload[:tags]
            key_name = "#{name.to_s.capitalize}.#{measurement}"
            if action == :increment
              $statsd.increment key_name, :tags => tags
            else
              $statsd.histogram key_name, value, :tags => tags
            end
          end
        end
      end
  end
end
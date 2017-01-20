require 'spec_helper'
require 'active_support/testing/time_helpers'

module DogStatsd::Instrumentation
  describe Request do
    def send_metric(payload={})
      ActiveSupport::Notifications.instrument('process_action.action_controller.duration', payload)
    end

    context 'with no configuration' do
      before(:each) { described_class.configure { |_|} }

      context 'with base payload empty' do
        it 'should measure duration' do
          expect_any_instance_of(Datadog::Statsd).to receive(:histogram).with('process_action.action_controller.duration', be_a(Numeric), tags: [])

          send_metric
        end

        it 'should measure custom runtime' do
          expect_any_instance_of(Datadog::Statsd).to receive(:histogram).with('process_action.action_controller.duration', be_a(Numeric), tags: [])
          expect_any_instance_of(Datadog::Statsd).to receive(:histogram).with('process_action.action_controller.db_runtime', be_a(Numeric), tags: [])

          send_metric 'db_runtime': 1
        end
      end

      context 'with populated payload' do
        it 'should produce tags' do
          expect_any_instance_of(Datadog::Statsd).to receive(:histogram).with('process_action.action_controller.duration', be_a(Numeric), tags: ['controller:controller', 'method:method', 'status:status', 'action:controller#action'])

          send_metric(
            {
              controller: 'controller',
              action: 'action',
              method: 'method',
              status: 'status',
            }
          )
        end
      end
    end

    context 'with default client configuration' do
      before(:each) {
        ClientProvider.configure do |config|
          config.tags = ['t:1']
        end
        described_class.configure { |_|}
      }

      it 'should measure duration' do
        allow_any_instance_of(Datadog::Statsd).to receive(:histogram) do |*args|
          expect(args[0].tags).to eq ['t:1']
        end

        send_metric
      end
    end
  end
end

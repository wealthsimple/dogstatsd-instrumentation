require 'spec_helper'
require 'active_support/testing/time_helpers'
require 'action_controller/api'

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

    context 'with feature disabled' do
      before(:each) do
        described_class.configure do |c|
          c.enabled = false
        end
      end

      it 'should do nothing' do
        expect_any_instance_of(Datadog::Statsd).to receive(:histogram).never
        send_metric
      end
    end

    context 'with base tags' do
      let(:base_tags) { {t1: 1} }

      before(:each) do
        described_class.configure do |c|
          c.base_tags = base_tags
        end
      end

      it 'should receive base tags' do
        expect_any_instance_of(Datadog::Statsd).to receive(:histogram).with('process_action.action_controller.duration', be_a(Numeric), tags: Request::Subscriber.tagify(base_tags))
        send_metric
      end

      it 'should merge base tags' do
        expect_any_instance_of(Datadog::Statsd).to receive(:histogram).with('process_action.action_controller.duration', be_a(Numeric), tags: Request::Subscriber.tagify(base_tags.merge controller: 'controller'))
        send_metric controller: 'controller'
      end
    end
  end
end

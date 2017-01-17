require 'spec_helper'
require 'active_support/testing/time_helpers'
require 'action_controller/api'

describe DogStatsd::Instrumentation::Request do
  subject { described_class.configure { |_|} }

  context 'with base payload empty' do
    it 'should measure duration' do
      subject
      expect_any_instance_of(Datadog::Statsd).to receive(:histogram).with('process_action.action_controller.duration', be_a(Numeric), tags: [])

      ActiveSupport::Notifications.instrument('process_action.action_controller', {})
    end

    it 'should measure custom runtime' do
      subject
      expect_any_instance_of(Datadog::Statsd).to receive(:histogram).with('process_action.action_controller.duration', be_a(Numeric), tags: [])
      expect_any_instance_of(Datadog::Statsd).to receive(:histogram).with('process_action.action_controller.db_runtime', be_a(Numeric), tags: [])

      ActiveSupport::Notifications.instrument('process_action.action_controller', {'db_runtime': 1})
    end
  end

  context 'with populated payload' do
    it 'should produce tags' do
      subject
      expect_any_instance_of(Datadog::Statsd).to receive(:histogram).with('process_action.action_controller.duration', be_a(Numeric), tags: ['controller:controller', 'action:action', 'method:method', 'status:status'])

      ActiveSupport::Notifications.instrument('process_action.action_controller', {
        controller: 'controller',
        action: 'action',
        method: 'method',
        status: 'status',
      })
    end
  end
end

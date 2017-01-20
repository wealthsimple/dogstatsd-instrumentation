require 'spec_helper'
require 'active_support/testing/time_helpers'

describe DogStatsd do
  def send_metric(payload={})
    ActiveSupport::Notifications.instrument('process_action.action_controller.duration', payload)
  end

  context 'with no configuration' do
    subject { described_class }

    context 'with base payload empty' do
      it 'should call underlying client' do
        expect_any_instance_of(Datadog::Statsd).to receive(:increment).with('test')

        subject.increment 'test'
      end
    end
  end
end

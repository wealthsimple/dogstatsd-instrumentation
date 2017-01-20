require 'spec_helper'
require 'active_support/testing/time_helpers'

module DogStatsd::Instrumentation
  describe ClientProvider do
    subject { ClientProvider.new }

    context 'with default configuration' do
      before(:each) do
        described_class.configure do |config|
          config.tags = []
          config.tags_h = {}
        end
      end

      its(:class) { is_expected.to eq Datadog::Statsd }
      its(:tags) { is_expected.to eq [] }
    end

    context 'with feature disabled' do
      before(:each) do
        described_class.configure do |config|
          config.enabled = false
        end
      end

      subject { ClientProvider.new.increment 'test' }

      it 'should not send metrics' do
        expect_any_instance_of(UDPSocket).to receive(:send).never
        subject
      end
    end

    context 'with tags' do
      before(:each) do
        described_class.configure do |config|
          config.tags = ['t1:1']
          config.tags_h = {t2: 2}
        end
      end

      subject { ClientProvider.new }

      it 'should add tags to metric' do
        expect(Datadog::Statsd).to receive(:new).with("127.0.0.1", 8125, {:namespace => nil, :tags => ["t1:1", "t2:2"]}, 50)
        subject
      end
    end
  end
end

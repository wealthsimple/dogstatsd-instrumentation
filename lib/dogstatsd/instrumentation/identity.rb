# frozen_string_literal: true

module Dogstatsd
  module Instrumentation
    # Gem identity information.
    module Identity
      def self.name
        "dogstatsd-instrumentation"
      end

      def self.label
        "Dogstatsd::Instrumentation"
      end

      def self.version
        "0.1.0"
      end

      def self.version_label
        "#{label} #{version}"
      end
    end
  end
end
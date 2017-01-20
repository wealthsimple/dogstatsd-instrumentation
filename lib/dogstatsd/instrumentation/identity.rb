# frozen_string_literal: true

module DogStatsd
  module Instrumentation
    # Gem identity information.
    module Identity
      def self.name
        "dogstatsd-instrumentation"
      end

      def self.label
        "DogStatsd::Instrumentation"
      end

      def self.version
        "0.1.4"
      end

      def self.version_label
        "#{label} #{version}"
      end
    end
  end
end

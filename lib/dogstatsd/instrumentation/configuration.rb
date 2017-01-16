module AwsCron
  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  def self.reset_configuration!
    @configuration = Configuration.new
  end

  class Configuration
    ATTRIBUTES = [:logger, :exception_handler]
    attr_accessor *ATTRIBUTES

    def initialize
      @logger ||= Logger.new(STDOUT)
    end
  end
end

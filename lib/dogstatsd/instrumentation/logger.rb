module AwsCron
  def self.log(method, text)
    @logger ||= ActiveSupport::TaggedLogging.new(configuration.logger)
    @tag ||= "aws_cron_#{SecureRandom.uuid}"
    @logger.tagged(@tag) { @logger.send(method, text) }
  end
end

module AwsCron
  def self.exception_handler(exception, message, data={})
    return  if configuration.exception_handler.nil?
    configuration.exception_handler.error(exception, message, data)
  end
end

require 'parse-cron'

module AwsCron

  # Cron runner that runs a schedule based on provided time_provider
  # You should avoid using this class directly
  class CronRunner
    def initialize(cron_str, time_provider=Time, leniency_secs=30*60)
      @cron = ::CronParser.new(cron_str, time_provider)
      @time_provider = time_provider
      @leniency_secs = leniency_secs
    end

    def run(time=@time_provider.now, &block)
      if should_run(time)
        yield
      end
    end

    def should_run(time)
      last_execution_time = @cron.last(time)
      next_execution_time = @cron.next(time)

      # Addresses 'parse-cron' behaviour of not being able to tell
      # if the cron schedule matches the current time.
      # If your cron should run at 9AM, asking
      # CronParser at exactly 9AM will yield:
      #   last: yesterday 9AM
      #   next: tomorrow 9AM
      #
      # But at 9:01AM, it will yield:
      #   last: today 9AM
      #   next: tomorrow 9AM
      current_execution_time = @cron.last(time + 1.minute)

      time_matches?(time, last_execution_time) || time_matches?(time, next_execution_time) || time_matches?(time, current_execution_time)
    end

    def time_matches?(time, reference_time)
      time >= reference_time - @leniency_secs && time < reference_time + @leniency_secs
    end
  end
end

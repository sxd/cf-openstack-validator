require 'rspec/core'

class TestsuiteFormatter < RSpec::Core::Formatters::DocumentationFormatter
  RSpec::Core::Formatters.register self, :dump_failures, :dump_pending, :dump_summary

  def initialize(output)
    super
  end

  def dump_failures(notification)
    return if notification.failure_notifications.empty?
    formatted = "\nFailures:\n"
    notification.failure_notifications.each_with_index do |failure, index|
      formatted << formatted_failure(failure, index)
    end
    output.puts formatted
  end

  def dump_pending(notification)
  end

  def dump_summary(summary)
    output.puts "\nFinished in #{summary.formatted_duration} " \
                    "(files took #{summary.formatted_load_time} to load)\n" \
                    "#{summary.colorized_totals_line}\n"
  end

  private

  def formatted_failure(failure, failure_number, colorizer = ::RSpec::Core::Formatters::ConsoleCodes)
    formatted = "\n  #{failure_number}) #{failure.description}\n"
    formatted << colorizer.wrap("     #{failure.exception.message}\n", RSpec.configuration.failure_color)

    formatted
  end
end
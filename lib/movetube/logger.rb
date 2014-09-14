require 'colorize'

# A logging utility.
class Movetube::Logger
  # The success mark that is prepended to success messages.
  SUCCESS_MARK = '✓'.colorize(:green)

  # The error mark that is prepended to error messages.
  ERROR_MARK = '✗'.colorize(:red)

  # Print out an error to `err`.
  # @param [String] msg The message to print
  # @param [IO] err An IO stream
  # @return [void]
  def self.error(msg, err = $stderr)
    msg = "#{ERROR_MARK} #{msg}"
    puts(msg, err)
  end

  # Print out a *success* message to stdout.
  # @param [String] msg The message to print
  # @param [IO] out An IO stream
  # @return [void]
  def self.success(msg, out = $stdout)
    msg = "#{SUCCESS_MARK} #{msg}"
    puts(msg, out)
  end

  class << self
    private

    # Print out a message to a given IO stream.
    # @param [String] msg
    # @param [IO] io
    # @return [void]
    def puts(msg, io)
      io.puts(msg)
    end
  end
end

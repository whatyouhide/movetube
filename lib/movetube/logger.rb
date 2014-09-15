require 'colorize'

# A logging utility.
class Movetube::Logger
  # An hash of 'marks', which are unicode symbols associated with types of
  # messages (eg. `✓` stands for 'success').
  MARKS = {
    success: '✓'.colorize(:green),
    error: '✗'.colorize(:red),
    warning: '⚠'.colorize(:yellow)
  }

  # Create a new logger instance.
  # @param [IO] out The stream used as a stdout
  # @param [IO] err The stream used as a stderr
  def initialize(out = $stdout, err = $stderr)
    @out, @err = out, err
  end

  # Print out a *success* message to the designated stdout.
  # @param [String] msg The message to print
  # @return [void]
  def success(msg)
    output_msg_using_mark msg, :success, @out
  end

  # Print out a *error* message to the designated stderr.
  # @param [String] msg The message to print
  # @return [void]
  def error(msg)
    output_msg_using_mark msg, :error, @err
  end

  # Print out a *warning* message to the designated stdout.
  # @param [String] msg The message to print
  # @return [void]
  def warning(msg)
    output_msg_using_mark(msg, :warning, @out)
  end

  # Regularly print to the designated stdout.
  # @param [String] msg The message to print
  # @return [void]
  def print(msg)
    @out.puts msg
  end

  private

  # Output a message on `io`, prepending it with `MARKS[mark]`.
  # @param [String] msg
  # @param [Symbol] mark
  # @param [IO] io
  def output_msg_using_mark(msg, mark, io)
    io.puts "#{MARKS[mark]} #{msg}"
  end
end

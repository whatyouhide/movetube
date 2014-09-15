require 'colorize'

# A logging utility.
class Movetube::Logger
  # An hash of 'marks', which are unicode symbols associated with types of
  # messages (eg. `✓` stands for 'success').
  MARKS = {
    success: '✓'.colorize(:green),
    error: '✗'.colorize(:red),
    warning: '⚠'.colorize(:yellow),
    info: '☞'.colorize(:cyan)
  }

  # Create a new logger instance.
  # @param [IO] out The stream used as a stdout
  # @param [IO] err The stream used as a stderr
  def initialize(out = $stdout, err = $stderr)
    @out, @err = out, err
    @silent_mode = false
  end

  # Set the logger to silent mode: in this mode, the logger only outputs error
  # messages.
  def silence!
    @silent_mode = true
  end

  # Print out a *success* message to the designated stdout.
  # @param [String] msg The message to print
  # @return [void]
  def success(msg)
    output_msg_using_mark(msg, :success)
  end

  # Print out a *error* message to the designated stderr.
  # @param [String] msg The message to print
  # @return [void]
  def error(msg)
    output_msg_using_mark(msg, :error, @err)
  end

  # Print out an *info* message to the designated stdout.
  # @param [String] msg The message to print
  # @return [void]
  def info(msg)
    output_msg_using_mark(msg, :info)
  end

  # Print out a *warning* message to the designated stdout.
  # @param [String] msg The message to print
  # @return [void]
  def warning(msg)
    output_msg_using_mark(msg, :warning)
  end

  # Regularly print to the designated stdout.
  # @param [String] msg The message to print
  # @return [void]
  def print(msg)
    @out.puts(msg) unless @silent_mode
  end

  private

  # Output a message on `io`, prepending it with `MARKS[mark]`.
  # If the silent mode has been set (through a call to `silence!`), output the
  # message only if it is directed to `@err`.
  # @param [String] msg
  # @param [Symbol] mark
  # @param [IO] io
  def output_msg_using_mark(msg, mark, io = @out)
    if io == @err || !@silent_mode
      io.puts "#{MARKS[mark]} #{msg}"
    end
  end
end

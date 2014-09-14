require 'yaml'

# CLI for the movetube executable.
class Movetube::CLI
  # Some messages to show on the console.
  MESSAGES = YAML.load_file File.expand_path('../../../messages.yml', __FILE__)

  # Start the Cri runner.
  def self.run(argv)
    Command.run(argv)
  end

  # Run the cli app with the arguments that `Cri` has parsed.
  # @param [Hash] opts An hash of command-line options
  # @param [Array] args An array of arguments
  # @param cmd The `cmd` object created by `Cri`
  def run!(opts, args, cmd)
    read_default_configs
    @options = format_options(opts)
    @args = args

    show_help(cmd.help) if @options[:help] || args.empty?

    Movetube.config.verbose = @options[:verbose]

    source_dirs
    destination_dir
  end

  private

  # Return the source directories inferred from the command-line arguments.
  # @return [Array] An array of directories (absolute paths)
  def source_dirs
    @args
      .map { |arg| File.expand_path(arg) }
      .select { |arg| File.directory?(arg) }
  end

  # Return the destination directory (from the config file or the --dest option)
  # and exit if there is none.
  # @return [String] The absolute path of the destination directory
  def destination_dir
    dest = @options.fetch(:dest, Movetube.config.destination_dir)
    exit_with_error(:no_destination_dir) unless dest
    File.expand_path(dest)
  end

  # Read default configurations from the `Movetube.config_file` (which is a
  # path) file.
  # @return [void]
  def read_default_configs
    return unless File.exist?(Movetube.config_file)
    configs = YAML.load_file(Movetube.config_file)
    return false unless configs

    Movetube.config.destination_dir = configs['destination_dir']
  end

  # Given an hash of options, return a copy of that hash with the `:show` and
  # `:season` keys moved to a nested hash stored under the `forced_data` key.
  # @param [Hash] opts
  # @return [Hash]
  def format_options(opts)
    # Replace options[:no-verbose] with options[:verbose].
    # Default verbose to false.
    opts[:verbose] = !opts.delete(:'no-verbose') || false

    opts.merge(forced_data: {
      show: opts.delete(:show),
      season: opts.delete(:season)
    })
  end

  # Show a given help message and **exit** with 0.
  # @param [String] help_message
  def show_help(help_message)
    puts help_message
    exit true
  end

  # Exit after printing an error message to the console.
  # @param [String,Symbol] msg If `msg` is a symbol, it will be used to look up
  #   an error messages in `messages.yml` (under the `"error"` key) with the
  #   given name.
  def exit_with_error(msg)
    if msg.is_a?(Symbol)
      msg = MESSAGES['error'][msg.to_s]
    end

    Movetube::Logger.error(msg)
    exit false
  end
end

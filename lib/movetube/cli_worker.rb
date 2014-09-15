require 'yaml'
require 'colorize'

# CLI for the movetube executable.
class Movetube::CLIWorker
  # Some messages to show on the console.
  MESSAGES = YAML.load_file File.expand_path('../../../messages.yml', __FILE__)

  def initialize
    @logger = Movetube::Logger.new
  end

  # Run the cli app with the arguments that `Cri` has parsed.
  # @param [Hash] opts An hash of command-line options
  # @param [Array] args An array of arguments
  # @param cmd The `cmd` object created by `Cri`
  def run!(opts, args, cmd)
    read_default_configs
    @options, @args = opts, args

    show_help(cmd.help) if @options[:help] || args.empty?

    file_manager = Movetube::FileManager.new
    file_manager.source_dirs = source_dirs
    file_manager.dest_dir = destination_dir
    file_manager.options = prettify_options(@options)

    file_manager.go!
  rescue Errno::ENOENT, Movetube::FatalError => err
    @logger.error err.message
    exit false
  end

  private

  # Return a "prettified" copy of `options`.
  # @param [Hash] options An hash of options returned from the command line.
  # @return [void]
  def prettify_options(options)
    # Translate no-verbose to verbose, which defaults to true.
    options[:verbose] = !options.fetch(:'no-verbose', false)
    options.delete(:'no-verbose')

    options[:lang] = options.fetch(:lang, Movetube.config.lang)

    options[:dry_run] = options.delete(:'dry-run')

    options[:forced_data] = {
      show: options.delete(:show),
      season: options.delete(:season)
    }

    options
  end

  # Return the source directories inferred from the command-line arguments.
  # @return [Array] An array of directories (absolute paths)
  def source_dirs
    expanded = @args.map { |arg| File.expand_path(arg) }
    warn_about_non_directories(expanded)
    expanded.select { |arg| File.directory?(arg) }
  end

  # Return the destination directory (from the config file or the --dest option)
  # and exit if there is none.
  # @return [String] The absolute path of the destination directory
  def destination_dir
    dest = @options.fetch(:dest, Movetube.config.destination_dir)

    # If we don't have to move the files, who cares about the destination
    # directory?
    return nil unless @options[:move]

    if dest.nil?
      fail Movetube::NoDestinationDirectoryError,
        MESSAGES['error']['no_destination_dir']
    end

    File.expand_path(dest)
  end

  def warn_about_non_directories(files)
    files.reject { |f| File.directory?(f) }.each do |non_dir|
      @logger.warning \
        "#{non_dir.to_s.colorize :blue} doesn't exist or is not a directory"
    end
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

  # Show a given help message and **exit** with 0.
  # @param [String] help_message
  def show_help(help_message)
    @logger.print help_message
    exit true
  end
end

require 'cri'

# CLI for the movetube executable.
class Movetube::CLI
  # Start the Cri runner.
  def self.run(argv)
    Command.run(argv)
  end

  # Show a given help message and **exit** with 0.
  # @param [String] help_message
  def self.show_help(help_message)
    puts help_message
    exit true
  end

  Command = Cri::Command.define do
    # Command infos.
    name        'movetube'
    usage       'movetube [options] SOURCE [DESTINATION]'
    summary     'Rename and/or move TV show episodes and subtitles.'
    description 'TODO'

    # Help flag.
    flag :h, :help, 'Show this help'

    # Whether to rename/move files.
    flag :r, :rename, 'Rename files in the source directory'
    flag :m, :move, 'Move files from the source directory to the destination'

    # Dry run.
    flag nil, :'dry-run', "Don't actually do anything"

    # Show, season and episode options.
    required nil, :show, 'Force a show name'
    required nil, :season, 'Force a season number'

    # Runner block.
    run do |opts, args, cmd|
      Movetube::CLI.show_help(cmd.help) if opts[:help]

      forced_data = opts.only_keys(:show, :season)
    end
  end
end

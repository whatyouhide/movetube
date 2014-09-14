require 'cri'

Movetube::CLI::Command = Cri::Command.define do
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

  # Verbose (which is on by default).
  flag nil, :'no-verbose', 'Disable verbosity (is on by default)'

  # Dry run.
  flag nil, :'dry-run', "Don't actually do anything"

  # Move files to a different destination directory than the default one.
  required :d, :dest, 'A destination directory which is not the default one'

  # Show, season and episode options.
  required nil, :show, 'Force a show name'
  required nil, :season, 'Force a season number'

  # Runner block.
  run { |opts, args, cmd| Movetube::CLI.new.run!(opts, args, cmd) }
end

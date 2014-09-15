require 'cri'

Movetube::CLI = Cri::Command.define do
  # Command infos.
  name        'movetube'
  usage       'TODO'
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
  flag :n, :'dry-run', "Don't actually do anything"

  # Move files to a different destination directory than the default one.
  required :d, :dest, 'A destination directory which is not the default one'

  # Subtitles language.
  required :l, :lang, 'The language for the subtitles'

  # Show, season and episode options.
  required nil, :show, 'Force a show name'
  required nil, :season, 'Force a season number'

  # Runner block.
  run { |opts, args, cmd| Movetube::CLIWorker.new.run!(opts, args, cmd) }
end

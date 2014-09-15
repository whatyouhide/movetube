module Movetube
  FatalError = Class.new(StandardError)

  NoDestinationDirectoryError = Class.new(FatalError)
  NotASubtitleError = Class.new(FatalError)
  NoLanguageSpecifiedError = Class.new(FatalError)
end

module Movetube
  FatalError = Class.new(StandardError)

  NotASubtitleError = Class.new(FatalError)
  NoLanguageSpecifiedError = Class.new(FatalError)
end

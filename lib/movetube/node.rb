require 'movetube/parser'

class Movetube::Node
  attr_reader :show, :season, :episode, :extension

  VALID_EXTENSIONS = Movetube::VIDEO_EXTENSIONS + Movetube::SUBTITLE_EXTENSIONS

  def initialize(filename)
    @filename = filename
    data = Movetube::Parser.parse(@filename)

    @show = data[:show]
    @season = data[:season]
    @episode = data[:episode]
    @extension = data[:extension]
  end

  def valid?
    Movetube::Parser.parsable?(@filename) && valid_extension?
  end

  def episode?
    valid? && Movetube::VIDEO_EXTENSIONS.include?(@extension)
  end

  def subtitle?
    valid? && Movetube::SUBTITLE_EXTENSIONS.include?(@extension)
  end

  private

  def valid_extension?
    VALID_EXTENSIONS.include?(@extension)
  end
end

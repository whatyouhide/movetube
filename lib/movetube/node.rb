require 'movetube/parser'

# A generic node is an episode or a subtitle which points to a file on the disk.
class Movetube::Node
  # @!attribute [r] show
  #   @return the show name
  # @!attribute [r] season
  #   @return the season number
  # @!attribute [r] episode
  #   @return the episode number
  # @!attribute [r] extension
  #   @return the extension of the source file
  attr_reader :show, :season, :episode, :extension

  # All the recognized extensions, both for video files and subtitles.
  VALID_EXTENSIONS = Movetube::VIDEO_EXTENSIONS + Movetube::SUBTITLE_EXTENSIONS

  # Create a new `Node` from a given `path`.
  # @param [String] path The path that points to the node's source file.
  def initialize(path)
    @path = path
    @filename = File.basename(path)
    data = Movetube::Parser.parse(@filename)

    @show = data[:show]
    @season = data[:season]
    @episode = data[:episode]
    @extension = data[:extension]
  end

  # Whether the file is a valid episode or subtitle.
  # @return [Boolean] `true` if the filename is parsable and its extension is
  #   valid, `false` otherwise.
  def valid?
    Movetube::Parser.parsable?(@filename) && valid_extension?
  end

  # Whether this node is an episode.
  def episode?
    valid? && Movetube::VIDEO_EXTENSIONS.include?(@extension)
  end

  # Whether this node is a subtitle.
  def subtitle?
    valid? && Movetube::SUBTITLE_EXTENSIONS.include?(@extension)
  end

  private

  # Whether the extension of this node is a recognized extension.
  def valid_extension?
    VALID_EXTENSIONS.include?(@extension)
  end
end

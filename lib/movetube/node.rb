require 'movetube/parser'

# A generic node is an episode or a subtitle which points to a file on the disk.
# @todo Add more documentation on how to use a Node by itself, requiring it
#   specifically to use it programmatically, not with a command line tool.
class Movetube::Node
  # @!attribute [r] show
  #   @return [String] the show name
  # @!attribute [r] season
  #   @return [Fixnum] the season number
  # @!attribute [r] episode
  #   @return [Fixnum] the episode number
  # @!attribute [r] extension
  #   @return [String] the extension of the source file
  attr_reader :show, :season, :episode, :extension

  # All the recognized extensions, both for video files and subtitles.
  VALID_EXTENSIONS = Movetube::VIDEO_EXTENSIONS + Movetube::SUBTITLE_EXTENSIONS

  # Create a new `Node` from a given `path`.
  # @param [String] path The path that points to the node's source file.
  # @param [Hash] forced_data Metadata from this hash will be preferred over
  #   metadata inferred from the filename.
  # @option forced_data [String] :show The show name
  # @option forced_data [String,Fixnum] :season The season number
  # @option forced_data [String,Fixnum] :episode The episode number
  # @option forced_data [String] :extension The extension of the file, without
  #   the leading `"."`
  def initialize(path, forced_data = {})
    @path = path
    @filename = File.basename(path)
    data = Movetube::Parser.parse(@filename)

    @show = forced_data[:show] || data[:show]
    @season = forced_data[:season] || data[:season]
    @episode = forced_data[:episode] || data[:episode]
    @extension = forced_data[:extension] || data[:extension]
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

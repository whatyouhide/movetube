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
  # @!attribute [r] language
  #   @return [String] the language code for this subtitle
  attr_reader :show, :season, :episode, :extension, :language

  # All the recognized extensions, both for video files and subtitles.
  VALID_EXTENSIONS = Movetube::VIDEO_EXTENSIONS + Movetube::SUBTITLE_EXTENSIONS

  # Create a new `Node` from a given `path`.
  # @param [String] filename The filename of a file
  # @param [Hash] forced_data Metadata from this hash will be preferred over
  #   metadata inferred from the filename
  # @option forced_data [String] :show The show name
  # @option forced_data [String,Fixnum] :season The season number
  def initialize(filename, forced_data = {})
    @filename = filename
    data = Movetube::Parser.parse(@filename)

    @extension = data[:extension]
    @episode = data[:episode]
    @show = forced_data[:show] || resolve_alias(data[:show])
    @season = forced_data[:season] || data[:season]
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

  # Set the language of this node, but raise an exception if this node is not a
  # subtitle.
  # @param [String] lang A language code
  # @raise [NotASubtitleError] if this node is not a subtitle
  # @return [String] The `lang` parameter
  def language=(lang)
    raise Movetube::NotASubtitleError, 'Not a subtitle' unless subtitle?
    @language = lang
  end

  # Format the node in a (Plex?) friendly way:
  #
  # `[show] - s[season]e[episode].[extension]`
  #
  # or, if it's a subtitle:
  #
  # `[show] - s[season]e[episode].[language].[extension]`
  # @return [String]
  def format
    base = @show + ' - '
    base << "s%02de%02d" % [@season, @episode]
    base << '.' + @language if subtitle?
    base << '.' + @extension
  end

  private

  # Whether the extension of this node is a recognized extension.
  def valid_extension?
    VALID_EXTENSIONS.include?(@extension)
  end

  def resolve_alias(show)
    real, _aliases = Movetube.config.aliases.find(proc { show }) do |(real, aliases)|
      aliases.include?(show) && real
    end

    real
  end
end

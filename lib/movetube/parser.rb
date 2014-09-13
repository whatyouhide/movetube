# A parser to extract metadata from a filename.
class Movetube::Parser
  # The regular expression that extracts the season and the episode from a
  # filename.
  SEASON_EPISODE_REGEX = /
  (
    s(?<season>\d{1,3}) e(?<episode>\d{1,3})
  ) | (
    (?<season>\d{1,3}) x (?<episode>\d{1,3})
  )
  /xi

  # Return a hash of metadata given a filename.
  # @param [String] filename A filename of an episode or a subtitle. Note that
  #   the filename isn't the complete path, but just the *basename*.
  # @return [Hash] An hash with keys `:show`, `:season`, `:episode` and
  #  `:extension`.
  def self.parse(filename)
    self.new.parse(filename)
  end

  # Whether the given filename is parsable as an episode/subtitle or not.
  # @param [String] filename The filename (which is the *basename*, not the full
  #   path).
  # @return [Boolean]
  def self.parsable?(filename)
    !self.new.parse(filename).has_value?(nil)
  end

  # This method is here so that `Parser.parse` can create a new `Parser`
  # instance and call this method on it. It's not meant to be used publicly.
  #
  # @param [String] filename The filename (which is the *basename*, not the full
  #   path).
  # @return [Hash]
  # @private
  # @see Movetube::Parser.parse
  def parse(filename)
    @filename = clean_filename(filename)

    {
      show: extract_show,
      season: extract_season,
      episode: extract_episode,
      extension: extract_extension
    }
  end

  private

  # Convert each occurrence of `"_"` in `"."` in the given `filename`.
  # @param [String] filename
  # @return [String]
  def clean_filename(filename)
    filename.gsub('_', '.').chomp
  end

  # Extract the show name from `@filename`.
  # @return [String] if a match is found.
  # @return [nil] if no match is found.
  def extract_show
    show = @filename
      .scan(/\w+/)
      .take_while { |w| w !~ SEASON_EPISODE_REGEX }
      .map(&:capitalize)
      .join(' ')
      .gsub(' S ', "'s ")

    show.empty? ? nil : show
  end

  # Extract the season number from `@filename`.
  # @return [Fixnum] if a match is found.
  # @return [nil] if no match is found.
  def extract_season
    match = SEASON_EPISODE_REGEX.match(@filename)
    match && match[:season].to_i
  end

  # Extract the episode number from `@filename`.
  # @return [Fixnum] if a match is found.
  # @return [nil] if no match is found.
  def extract_episode
    match = SEASON_EPISODE_REGEX.match(@filename)
    match && match[:episode].to_i
  end

  # Extract the extension from `@filename`.
  # @return [String] if a match is found.
  # @return [nil] if no match is found.
  def extract_extension
    File.extname(@filename)[1..-1]
  end
end

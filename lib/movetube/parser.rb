class Movetube::Parser
  SEASON_EPISODE_REGEX = /
  (
    s(?<season>\d{1,3}) e(?<episode>\d{1,3})
  ) | (
    (?<season>\d{1,3}) x (?<episode>\d{1,3})
  )
  /xi

  def self.parse(filename)
    self.new.parse(filename)
  end

  def self.parsable?(filename)
    !self.new.parse(filename).has_value?(nil)
  end

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

  def clean_filename(filename)
    filename.gsub('_', '.').chomp
  end

  def extract_show
    @filename
      .scan(/\w+/)
      .take_while { |w| w !~ SEASON_EPISODE_REGEX }
      .map(&:capitalize)
      .join(' ')
      .gsub(' S ', "'s ")
  end

  def extract_season
    match = SEASON_EPISODE_REGEX.match(@filename)
    match && match[:season].to_i
  end

  def extract_episode
    match = SEASON_EPISODE_REGEX.match(@filename)
    match && match[:episode].to_i
  end

  def extract_extension
    File.extname(@filename)[1..-1]
  end
end

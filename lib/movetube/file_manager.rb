require 'pathname'
require 'fileutils'
require 'colorize'

# This class is responsible for moving/renaming the actual files.
class Movetube::FileManager
  attr_accessor :options, :source_dirs, :dest_dir

  def initialize
    @logger = Movetube::Logger.new
  end

  # "Launch" the app.
  def go!
    @logger.silence! unless @options[:verbose]

    @source_dirs.each do |dir|
      Pathname.new(dir).each_child do |child|
        take_care_of_file(child) unless dotted?(child)
      end
    end
  end

  private

  def take_care_of_file(pathname)
    node = create_node_from_pathname(pathname)

    unless node.valid?
      @logger.info "#{'Skipping'.colorize :white}: #{pathname.basename}"
      return
    end

    add_language_to(node) if node.subtitle?

    rename(node, pathname) if @options[:rename]
  end

  # Add the language specified in the options to the given node.
  # @param [Node] node
  # @raise [NoLanguageSpecifiedError] if no language have been specified
  # @return [String] The newly set language
  def add_language_to(node)
    if @options[:lang].nil?
      fail Movetube::NoLanguageSpecifiedError,
        'There were subtitles and there was no language specified'
    end

    node.language = @options[:lang]
  end

  # Whether a file identified by `pathname` starts with a `"."`.
  # @param [Pathname] pathname
  # @return [Boolean]
  def dotted?(pathname)
    pathname.basename.to_s.start_with?('.')
  end

  # Create an instance of `Movetube::Node` from a given pathname.
  # @param [Pathname] pathname
  # @return [Node]
  def create_node_from_pathname(pathname)
    Movetube::Node.new(pathname.basename.to_s, @options[:forced_data])
  end

  def rename(node, original_pathname)
    from = original_pathname.to_s
    to = original_pathname.dirname.join(node.format).to_s

    if @options[:dry_run]
      @logger.info "Would rename #{from.colorize :blue} to #{to.colorize :blue}"
    else
      File.rename(from, to)
      @logger.success "Renamed #{from.colorize :blue} to #{to.colorize :blue}"
    end
  end

  def move(node, pathname)
  end
end

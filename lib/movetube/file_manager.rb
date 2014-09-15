require 'pathname'
require 'fileutils'
require 'colorize'

# This class is responsible for moving/renaming the actual files.
class Movetube::FileManager
  # @!attribute [w] options
  #   @return [Hash] an hash of options
  # @!attribute [w] source_dirs
  #   @return [Array] an array of source directories (absolute paths)
  # @!attribute [w] dest_dir
  #   @return [String] a destination directory (absolute path)
  attr_accessor :options, :source_dirs, :dest_dir

  def initialize
    @logger = Movetube::Logger.new
  end

  # Set the `@options` instance variable and, once we have the options
  # available, create a new internal instance of `FileOperator` passing the
  # `dry_run` option by.
  # @param [Hash] opts
  # @return [void]
  def options=(opts)
    @options = opts
    @file_operator = Movetube::FileOperator.new(dry_run: opts[:dry_run])
  end

  # "Launch" the app.
  def go!
    @logger.silence! unless @options[:verbose]
    @source_dirs.each { |dir| take_care_of_directory(Pathname.new(dir)) }
  end

  private

  # Operate on all the files in the given directory's pathname.
  # @param [Pathname] dir_pathname
  # @return [void]
  def take_care_of_directory(dir_pathname)
    children = dir_pathname.children.reject { |c| dotted?(c) }

    if children.empty?
      @logger.info "No files found in #{dir_pathname.to_s.colorize :yellow}"
      return
    end

    children.each { |child| take_care_of_file(child) }
  end

  # Operate on a single file identified by `pathname`.
  # @param [Pathname] pathname
  # @return [void]
  def take_care_of_file(pathname)
    node = create_node_from_pathname(pathname)

    unless node.valid?
      @logger.info "#{'Skipping'.colorize :white}: #{pathname}"
      return
    end

    add_language_to(node) if node.subtitle?

    new_path = rename(node, pathname) if @options[:rename]
    move(node, new_path || pathname) if @options[:move]
  end

  # Add the language specified in the options to the given node.
  # @param [Node] node
  # @raise [NoLanguageSpecifiedError] if no language have been specified **and**
  #   we are trying to rename files. If we want to just move, so be it.
  # @return [String] The newly set language
  def add_language_to(node)
    if @options[:lang].nil? && @options[:rename]
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

  # Rename a node if --dry-run has not been used, otherwise just log what would
  # have been done.
  # @param [Node] node The node to rename (this is used in order to have a
  #   formatted name
  # @param [Pathname] original_pathname
  def rename(node, original_pathname)
    @file_operator.rename(original_pathname, node.format)
  end

  # Move a node (identified by `pathname`) to the destination directory (after
  # creating the necessary directory structure if it didn't exist already).
  # @param [Node] node
  # @param [Pathname] pathname
  # @return [void]
  def move(node, src_path)
    @file_operator.move(
      src_path,
      create_directory_structure_for(node) + src_path.basename.to_s
    )
  end

  # Create the necessary directory structure (in the designated destination
  # directory) in order to store `node`.
  # @param [Node] node
  # @return [Pathname] The directory structure, regardless of whether it was
  #   actually created
  def create_directory_structure_for(node)
    @file_operator.mkpath(dest_dir_for(node))
  end

  # Return the destination directory (including the show name and season number)
  # for the given node. For example, for `"Archer - s01e01.mkv"` that would be:
  #
  # `[destination_dir]/Archer/Season 1/`
  #
  # @param [Node] node
  # @return [Pathname]
  def dest_dir_for(node)
    Pathname.new(@dest_dir) + node.show + "Season #{node.season}"
  end
end

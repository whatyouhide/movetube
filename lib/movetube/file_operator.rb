require 'fileutils'
require 'pathname'

module Movetube
  class FileOperator
    def initialize(dry_run: true)
      @dry_run = dry_run
      @logger = Logger.new
    end

    # Create the directory identified by `path` unless it already exists.
    # @param [Pathname] path
    # @return [Pathname] The `path` argument, as is
    def mkpath(path)
      return path if path.exist?

      if @dry_run
        @logger.info "Would create directory: #{path.to_s.colorize :magenta}"
      else
        path.mkpath
        @logger.success "Created directory: #{path.to_s.colorize :magenta}"
      end

      path
    end

    # Rename `src_path` to `new_name`. Only the last component of `src_path` is
    # remove, **in place** (meaning the file stays in the same directory it was
    # before calling this method).
    # @param [Pathname] src_path
    # @param [String] new_name
    # @return [void]
    def rename(src_path, new_name)
      dest = src_path.dirname + new_name

      src_colored = src_path.to_s.colorize(:blue)
      dest_colored = dest.to_s.colorize(:blue)

      if @dry_run
        @logger.info "Would rename #{src_colored} to #{dest_colored}"
      else
        File.rename(src_path.to_s, dest.to_s)
        @logger.success "Renamed #{src_colored} to #{dest_colored}"
      end

      dest
    end

    # Move `src` to `dst`.
    # @param [Pathname] src
    # @param [Pathname] dst
    # @return [void]
    def move(src, dst)
      if @dry_run
        @logger.info \
          "Would move #{src.to_s.colorize :blue} to #{dst.to_s.colorize :blue}"
      else
        @logger.info 'Moving...'
        FileUtils.mv src.to_s, dst.to_s
        @logger.success \
          "Moved #{src.to_s.colorize :blue} to #{dst.to_s.colorize :blue}"
      end
    end
  end
end

require 'ostruct'

require 'movetube/version'
require 'movetube/constants'
require 'movetube/node'
require 'movetube/exceptions'
require 'movetube/logger'
require 'movetube/file_manager'
require 'movetube/file_operator'
require 'movetube/cli_worker'
require 'movetube/cli'

module Movetube
  class << self
    attr_accessor :config
    attr_accessor :config_file
  end

  Movetube.config ||= OpenStruct.new
  Movetube.config_file = File.join(Dir.home, '.movetuberc')
end

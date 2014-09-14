require 'ostruct'

require 'movetube/version'
require 'movetube/constants'
require 'movetube/node'
require 'movetube/logger'
require 'movetube/cli'
require 'movetube/cli_options'

module Movetube
  class << self
    attr_accessor :config
    attr_accessor :config_file
  end

  Movetube.config ||= OpenStruct.new
  Movetube.config_file = File.join(Dir.home, '.movetuberc')
end

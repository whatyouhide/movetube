# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'movetube/version'

Gem::Specification.new do |spec|
  spec.name          = 'movetube'
  spec.version       = Movetube::VERSION
  spec.authors       = ['Andrea Leopardi']
  spec.email         = 'an.leopardi@gmail.com'
  spec.homepage      = ''
  spec.license       = 'MIT'
  spec.summary       = 'Rename and move TV show episodes and subtitles.'
  spec.description   = <<-DESC
    Extract the metadata from the TV show episodes and subtitles filenames and
    use them to rename and/or move those files around.
  DESC

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  # Development dependencies.
  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'

  # Runtime dependencies.
  spec.add_runtime_dependency 'colorize'
  spec.add_runtime_dependency 'cri'
end

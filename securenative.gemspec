# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'securenative'

Gem::Specification.new do |spec|
  spec.name          = 'securenative'
  spec.version       = SecureNative::VERSION
  spec.authors       = ['SecureNative']
  spec.email         = ['support@securenative.com']
  spec.required_ruby_version = '>= 2.4'

  spec.summary       = 'SecureNative SDK for Ruby'
  spec.homepage      = 'https://www.securenative.com'
  spec.license       = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.test_files = Dir['spec//*']

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 12.3.3'
end

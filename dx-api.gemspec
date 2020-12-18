# frozen_string_literal: true

require_relative 'lib/dx/api/version'

Gem::Specification.new do |spec|
  spec.name          = 'dx-api'
  spec.version       = DX::Api::VERSION
  spec.authors       = ['Kurt Mueller']
  spec.email         = ['kurt.mueller@osumc.edu']

  spec.summary       = 'Access the DNAnexus api'
  spec.description   = 'Access the DNAnexus api'
  spec.homepage      = 'https://github.com/astor-ostor/dx-api'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['allowed_push_host'] = 'https://rubygems.pkg.github.com/ASTOR-OSTOR/'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/astor-ostor/dx-api'
  spec.metadata['changelog_uri'] = 'https://github.com/astor-ostor/dx-api/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler-audit'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-packaging'
  spec.add_development_dependency 'rubocop-performance'
  spec.add_development_dependency 'rubocop-require_tools'
  spec.add_development_dependency 'rubocop-rspec'
end

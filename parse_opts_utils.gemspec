# frozen_string_literal: true

require_relative "lib/parse_opts_utils/version"

Gem::Specification.new do |spec|
  spec.name          = "parse_opts_utils"
  spec.version       = ParseOptsUtils::VERSION
  spec.authors       = ["caligian"]
  spec.email         = ["caligian@protonmail.com"]

  spec.summary       = "Helper functions for parseopts"
  spec.description   = "Adds common functionality to params such as getting file content, splitting args, etc"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end

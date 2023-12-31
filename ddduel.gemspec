# frozen_string_literal: true

require_relative "lib/ddduel/version"

Gem::Specification.new do |spec|
  spec.name = "ddduel"
  spec.version = DDDuel::VERSION
  spec.authors = ["Jose D. Gomez R."]
  spec.email = ["jose.gomez@suse.com"]

  spec.summary = "PA_HAZER-T_ODO: Write a short summary, because RubyGems requires one."
  spec.description = "PA_HAZER-T_ODO: Write a longer description or delete this line."
  # spec.homepage = "PA_HAZER-T_ODO: Put your gem's website or public repo URL here."
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "PA_HAZER-T_ODO: Set to your gem server 'https://example.com'"

  # spec.metadata["homepage_uri"] # = spec.homepage
  # spec.metadata["source_code_uri"] # = "PA_HAZER-T_ODO: Put your gem's public repo URL here."
  # spec.metadata["changelog_uri"] # = "PA_HAZER-T_ODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end

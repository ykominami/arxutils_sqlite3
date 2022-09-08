# frozen_string_literal: true

require_relative "lib/arxutils_sqlite3/version"

Gem::Specification.new do |spec|
  spec.name          = "arxutils_sqlite3"
  spec.version       = Arxutils_Sqlite3::VERSION
  spec.authors       = ["yasuo kominami"]
  spec.email         = ["ykominami@gmail.com"]

  spec.summary       = "utility functions for ActiveRecord."
  spec.description   = "utility functions for ActiveRecord."
  spec.homepage      = "https://ykominami.github.io/arxutils_sqlite3/"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.5.0"

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'https://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  # spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  #p "====-"
  #p "spec.executables=#{spec.executables}"
  #p "====----"
  spec.add_runtime_dependency "activesupport"
  # spec.add_runtime_dependency "erb"
  # spec.add_runtime_dependency "activerecord", "~> 4.2"
  spec.add_runtime_dependency "activerecord", "~> 6.1"
  spec.add_runtime_dependency "sqlite3"
  # spec.add_runtime_dependency "mysql2" , "~> 0.4.1"
  #spec.add_runtime_dependency "encx"

  # spec.add_development_dependency "bundler", "~> 2.2.10"
  #spec.add_development_dependency "bundler"
  #spec.add_development_dependency "rake", ">= 12.3.3"
  #spec.add_development_dependency "rspec"
  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end

# frozen_string_literal: true

source "https://rubygems.org"

# Specify your gem's dependencies in arxutils_sqlite3.gemspec
gemspec

gem "simpleoptparse"
#gem "ykutils"
#gem "ykutils" , :path => "C:\Users\ykomi\cur\ruby\ykutils"
gem "ykutils" , :path => "../ykutils"
#gem "ykutils" , :github => "ykominami/ykutils"
#gem "ykutils" , "> 0.1.3"
gem "ykxutils", "> 0.1.0"

gem "activesupport"
  # spec.add_runtime_dependency "erb"
  # spec.add_runtime_dependency "activerecord", "~> 4.2"
gem "activerecord", "~> 6.1"
gem "sqlite3"
  # spec.add_runtime_dependency "mysql2" , "~> 0.4.1"
gem "encx"

  # spec.add_development_dependency "bundler", "~> 2.2.10"

group :development do
	gem "rake", "~> 13.0"

	gem "yard"
end

group :test do
	gem "rspec", "~> 3.0"

	gem "rubocop", "~> 1.7"
	gem "rubocop-rake"
	gem "rubocop-rspec"
end



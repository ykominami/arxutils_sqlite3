# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in arxutils_sqlite3.gemspec
gemspec

gem 'activesupport'
gem 'activerecord', '~> 6.1'
gem 'sqlite3'
gem 'simpleoptparse'
gem 'ykutils'
gem 'ykxutils'
gem 'bundler'
gem 'rake', '~> 13.0'

group :development do
  gem 'yard'
end

group :test, optional: true do
  gem "rspec", "~> 3.0"
  # gem "rspec"
  gem "rubocop", '~> 1.7'
  gem "rubocop-performance"
  gem "rubocop-rake"
  gem "rubocop-rspec"
  gem 'power_assert', '~> 1.1.5'
end

# group :test do
# end

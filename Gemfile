# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in arxutils_sqlite3.gemspec
gemspec

# gem 'activerecord', '~> 6.1.7.5'
gem 'activerecord', '~> 7.1.3.4'
gem 'activesupport'
gem 'base64'
gem 'nkf'
gem 'csv'
gem 'mutex_m'
gem 'bigdecimal'
gem 'bundler'
gem 'rake', '~> 13.1'
gem 'simpleoptparse'
# Use sqlite3 as the database for Active Record
gem "sqlite3", "~> 1.4"

# gem 'sqlite3' , '2.0.2'
#
gem 'ykutils'
gem 'ykxutils' # , path: '../ykxutils'

group :development, :test do
  gem 'power_assert', '~> 2.0.3'
end

group :development do
  gem 'yard', '~> 0.9.36'
  gem 'rufo'
end

group :test, optional: true do
  gem 'debug'
  # gem 'rspec-core'
  gem 'rspec', '~> 3.0'
  # gem 'rubocop', '~> 1.50'
  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'rubocop-rake', require: false
  gem 'rubocop-rspec', require: false
end

# group :test do
# end

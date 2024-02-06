# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in arxutils_sqlite3.gemspec
gemspec

gem 'activerecord', '~> 6.1.7.5'
gem 'activesupport'
gem 'base64'
gem 'nkf'
gem 'csv'
gem 'mutex_m'
gem 'bigdecimal'
gem 'bundler'
gem 'rake', '~> 13.1'
gem 'simpleoptparse'
gem 'sqlite3'
gem 'ykutils'
gem 'ykxutils'
# gem 'ykxutils' , path: "../ykxutils"

group :development, :test do
  gem 'power_assert', '~> 2.0.3'
end

group :development do
  gem 'yard'
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

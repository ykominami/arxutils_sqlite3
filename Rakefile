# frozen_string_literal: true

require 'bundler/gem_tasks'
# require "rake/testtask"

# Rake::TestTask.new do |t|
#  t.libs  << "test"
# end

# desc "Run test"
# task default: :test

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

require 'rubocop/rake_task'

RuboCop::RakeTask.new

# task default: %i[spec rubocop]

require 'arxutils_sqlite3/rake_task'

# frozen_string_literal: true
require 'bigdecimal'
require 'active_support'
require 'active_support/core_ext'
require 'active_record'

require_relative 'arxutils_sqlite3/version'
require_relative 'arxutils_sqlite3/arxutils_sqlite3'
require_relative 'arxutils_sqlite3/arx'
require_relative 'arxutils_sqlite3/transactstate'
require_relative 'arxutils_sqlite3/hier'
require_relative 'arxutils_sqlite3/migrate'
require_relative 'arxutils_sqlite3/dbutil/dbinit.rb'  
require_relative 'arxutils_sqlite3/dbutil/dbmgr.rb'

module Arxutils_Sqlite3
  class Error < StandardError; end
  # Your code goes here...
end

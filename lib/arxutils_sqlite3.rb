# frozen_string_literal: true

require "ykutils"
require "ykxutils"

require "bigdecimal"
require "active_support"
require "active_support/core_ext"
require "active_record"
require "pathname"

module Arxutils_Sqlite3
  TOP_DIR = Pathname(__FILE__).parent
  class Error < StandardError; end
  # Your code goes here...
end

require_relative "arxutils_sqlite3/dbutil"
require_relative "arxutils_sqlite3/config"
require_relative "arxutils_sqlite3/cli"

require_relative "arxutils_sqlite3/version"
require_relative "arxutils_sqlite3/arx"
require_relative "arxutils_sqlite3/transactstate"
require_relative "arxutils_sqlite3/hier"
require_relative "arxutils_sqlite3/migrate"
require_relative "arxutils_sqlite3/util"
require_relative "dbacrecord"

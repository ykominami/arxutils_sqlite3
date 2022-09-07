# frozen_string_literal: true
require "ykutils"
require "ykxutils"

require "bigdecimal"
require "active_support"
require "active_support/core_ext"
require "active_record"
require "pathname"

require_relative "arxutils_sqlite3/version"
require_relative "arxutils_sqlite3/arx"
require_relative "arxutils_sqlite3/transactstate"
require_relative "arxutils_sqlite3/hier"
require_relative "arxutils_sqlite3/migrate"
require_relative "arxutils_sqlite3/dbutil"

module Arxutils_Sqlite3
  TOP_DIR = Pathname(__FILE__).parent
  TEMPLATE_DIR = TOP_DIR.join("template")
  TEMPLATE_RELATION_DIR = TEMPLATE_DIR.join("relation")
  TEMPLATE_CONFIG_DIR = TEMPLATE_DIR.join("config")
  CONFIG_DIR = "config".freeze
  DEST_CONFIG_DIR = Pathname.new("config")
  DB_SCHEME_DIR = TEMPLATE_RELATION_DIR.join("db_scheme")
  DB_SCHEME_FILE = DB_SCHEME_DIR.join("db_scheme.yml")
  OPTS_FILE_NAME = "opts.rb"
  OPTS_FILE_NAME_2 = "opts"
  DBSETUP_FILE_NAME = "dbsetup.rb"
  DBSETUP_FILE_NAME_2 = "dbsetup"
  OPTS_FILE = DB_SCHEME_DIR.join(OPTS_FILE_NAME)
  DBSETUP_FILE = DB_SCHEME_DIR.join(DBSETUP_FILE_NAME)
  DEST_OPTS_FILE = DEST_CONFIG_DIR.join(OPTS_FILE_NAME)
  DEST_OPTS_FILE_2 = DEST_CONFIG_DIR.join(OPTS_FILE_NAME_2)
  DEST_DBSETUP_FILE = DEST_CONFIG_DIR.join(DBSETUP_FILE_NAME)
  DEST_DBSETUP_FILE_2 = DEST_CONFIG_DIR.join(DBSETUP_FILE_NAME_2)

  class Error < StandardError; end
  # Your code goes here...
end

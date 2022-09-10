require_relative "dbutil/dbconnect"

module Arxutils_Sqlite3
  # DB操作用ユーティリティクラス
  module Dbutil
    # DB格納ディレクトリ名
    DB_DIR = "db".freeze
    # migrate用スクリプト格納ディレクトリ名
    MIGRATE_DIR = "migrate".freeze
    # SQLITE3用DB構成名
    DBCONFIG_SQLITE3 = "sqlite3".freeze
    # MYSQL用DB構成名
    DBCONFIG_MYSQL = "mysql".freeze
    # DB構成格納用ディレクトリ名
    CONFIG_DIR = "config".freeze
    # データベース用ログファイル名
    DATABASELOG = "database.log".freeze
  end
end

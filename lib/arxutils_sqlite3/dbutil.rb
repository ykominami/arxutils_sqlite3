require_relative 'dbutil/dbinit.rb'  
require_relative 'dbutil/dbmgr.rb'

module Arxutils_Sqlite3
  # DB操作用ユーティリティクラス
  module Dbutil
    # DB格納ディレクトリ名
    DB_DIR = 'db'
    # migrate用スクリプト格納ディレクトリ名
    MIGRATE_DIR = 'migrate'
    # SQLITE3用DB構成名
    DBCONFIG_SQLITE3 = 'sqlite3'
    # MYSQL用DB構成名
    DBCONFIG_MYSQL = 'mysql'
    # DB構成格納用ディレクトリ名
    CONFIG_DIR = 'config'
    # データベース用ログファイル名
    DATABASELOG = 'database.log'

    # DB接続までの初期化を行う
  end
end

module Arxutils_Sqlite3
  class Util
    # DBログファイルへのパスの作成
    def self.make_log_path(db_dir, dbconfig)
      log_path = ""
      log_fname = Dbutil::Dbconnect.make_log_file_name(
        dbconfig, Config::DATABASELOG)
      if db_dir && log_fname
        # DB用ログファイルへのパス
        log_path = File.join(db_dir, log_fname)
      end
      log_path
    end

    # DB構成ファイルへのパスの作成
    def self.make_dbconfig_path(config_dir, dbconfig)
      Pathname.new(config_dir).join("#{dbconfig}.yml")
    end
  end
end

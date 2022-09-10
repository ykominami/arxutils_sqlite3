module Arxutils_Sqlite3
  class Util
    # migrateの準備
    def self.prepare_for_migrate(env, db_scheme_ary, db_dir, dbconfig_dest_path, opts)
      migrate_base_dir = Dbutil::MIGRATE_DIR
      # migrate用スクリプト格納ディレクトリへのパス
      migrate_dir = File.join(db_dir, migrate_base_dir)
      # DB構成ファイルの出力先ディレクトリ
      dest_config_dir = Dbutil::CONFIG_DIR
      dbconfig_src_fname = "#{opts["dbconfig"]}.tmpl"
      relation = opts[:relation]
      mig = Migrate.new(
        dbconfig_dest_path,
        dbconfig_src_fname,
        migrate_dir,
        db_dir,
        db_scheme_ary,
        relation,
        opts)
    end

    # DBログファイルへのパスの作成
    def self.make_log_path(db_dir, dbconfig)
      log_path = ""
      log_fname = Dbutil::Dbconnect.make_log_file_name(
        dbconfig, Dbutil::DATABASELOG)
      if db_dir && log_fname
        # DB用ログファイルへのパス
        log_path = File.join(db_dir, log_fname)
      end
      log_path
    end

    # DB構成ファイルへのパスの作成
    def self.make_dbconfig_path(config_dir, dbconfig)
      File.join( config_dir, "#{dbconfig}.yml")
    end
  end
end

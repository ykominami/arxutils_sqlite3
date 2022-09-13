module Arxutils_Sqlite3
  # CLI用クラス
  class Cli
    def initialize(config)
      @config = config
    end

    def setup(klass)
      @config.make_config_directory
      @config.setup_db_scheme_file
      @config.setup_opts_file(klass)
      @config.setup_setting_yaml_file(klass)
      #db_scheme_ary = nil
    end

    def makeconfig(dbconfig, relation, banner, exit_code, opts)
      db_scheme_ary = nil
      dbconfig_path = @config.make_dbconfig_path(dbconfig)
      @config.check_file_exist(dbconfig_path, banner, exit_code)
      mig = @config.prepare_for_migrate(db_scheme_ary, dbconfig_path, dbconfig, relation)
      mig.make_dbconfig(opts)
    end

    def migrate(yaml_pn, relation, klass, dbconfig, env)
      db_scheme_ary = YAML.load_file( yaml_pn )
      dbconfig_path = @config.make_dbconfig_path(dbconfig)

      dest_dbsetup_file = @config.get_dest_dbsetup_file
      @config.make_dbsetup_file(db_scheme_ary, relation, klass, dest_dbsetup_file)

      connect_time = Arxutils_Sqlite3::Dbutil::Dbconnect.db_connect(@config, dbconfig, env)

      # マイグレーション用スクリプトの生成、relationのクラス定義ファイルの生成
      mig = @config.prepare_for_migrate(db_scheme_ary, dbconfig_path, dbconfig, relation)
      mig.output

      # マイグレーション実行
      ActiveRecord::MigrationContext.new(mig.migrate_dir, ActiveRecord::SchemaMigration).up
    end

    def integrate(dbconfig, env)
      connect_time = Arxutils_Sqlite3::Dbutil::Dbconnect.db_connect(@config, dbconfig, env)
      Dbsetup.new(connect_time)
    end

    def delete(dbconfig, db_scheme_ary, relation)
      config_dir = @config.get_config_dir
      dbconfig_path = Arxutils_Sqlite3::Util.make_dbconfig_path(config_dir, dbconfig)
      mig = @config.prepare_for_migrate(db_scheme_ary, dbconfig_path, dbconfig, relation)
      mig.delete_migrate_and_config_and_db
    end

    def delete_db(dbconfig, db_scheme_ary, relation)
      config_dir = config.get_config_dir
      dbconfig_path = Arxutils_Sqlite3::Util.make_dbconfig_path(config_dir, dbconfig)
      mig = @config.prepare_for_migrate(db_scheme_ary, dbconfig_path, dbconfig, relation)
      # mig.delete_migrate_config_and_db
      mig.delete_db
    end

    def rm_dbconfig(dbconfig)
      dbconfig_path = @config.make_dbconfig_path(dbconfig)
      p dbconfig_path
      FileUtils.rm_f(dbconfig_path)
    end
  end
end

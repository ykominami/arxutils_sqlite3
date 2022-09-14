module Arxutils_Sqlite3
  # CLI用クラス
  class Cli
    def initialize(config, dbconfig, env)
      @config = config
      @dbconfig = dbconfig
      @env = env
    end

    def setup(klass)
      p "make_config_directory"
      @config.make_config_directory
      p "setup_db_scheme_file"
      @config.setup_db_scheme_file
      p "setup_opts_file(#{klass})"
      @config.setup_opts_file(klass)
      p "setup_setting_yaml_file(#{klass})"
      @config.setup_setting_yaml_file(klass)
      #db_scheme_ary = nil
    end

    def copy_db_scheme
      # DBスキームファイルが存在しなければ、サンプルファイルをDBスキームファイルとしてコピー
      @config.copy_db_scheme_file
    end

    def copy_opts_file
      # optsファイルが存在しなければ、サンプルファイルをoptsファイルとしてコピー
      @config.copy_opts_file
    end

    def makeconfig(acrecord, banner, exit_code, opts)
      db_scheme_ary = nil
      dbconfig_path = @config.make_dbconfig_path(@dbconfig)
      #@config.check_file_exist(dbconfig_path, banner, exit_code)
      mig = @config.prepare_for_migrate(db_scheme_ary, dbconfig_path, @dbconfig, acrecord)
      mig.make_dbconfig(opts)
    end

    def setup_for_migrate(yaml_pn, acrecord, klass)
      db_scheme_ary = YAML.load_file( yaml_pn )
      dbconfig_path = @config.make_dbconfig_path(@dbconfig)

      dest_dbsetup_file = @config.get_dest_dbsetup_file
      @config.make_dbsetup_file(db_scheme_ary, acrecord, klass, dest_dbsetup_file)

      # migrate用スクリプトの出力先ディレクトリ名
      migrate_dir = @config.get_migrate_dir
      # マイグレーション用スクリプトの生成、acrecordのクラス定義ファイルの生成
      mig = @config.prepare_for_migrate(db_scheme_ary, dbconfig_path, @dbconfig, acrecord)
      mig.output
    end

    def migrate
      # migrate用スクリプトの出力先ディレクトリ名
      migrate_dir = @config.get_migrate_dir

      connect_time = Arxutils_Sqlite3::Dbutil::Dbconnect.db_connect(@config, @dbconfig, @env)

      # マイグレーション実行
      ActiveRecord::MigrationContext.new(migrate_dir, ActiveRecord::SchemaMigration).up
    end

    def acr
      connect_time = Arxutils_Sqlite3::Dbutil::Dbconnect.db_connect(@config, @dbconfig, @env)
      Dbsetup.new(connect_time)
    end

    def delete(db_scheme_ary, acrecord)
      config_dir = @config.get_config_dir
      dbconfig_path = Arxutils_Sqlite3::Util.make_dbconfig_path(config_dir, @dbconfig)
      mig = @config.prepare_for_migrate(db_scheme_ary, dbconfig_path, @dbconfig, acrecord)
      mig.delete_migrate_and_config_and_db
    end

    def delete_db(db_scheme_ary, acrecord)
      config_dir = @config.get_config_dir
      dbconfig_path = Arxutils_Sqlite3::Util.make_dbconfig_path(config_dir, @dbconfig)
      mig = @config.prepare_for_migrate(db_scheme_ary, dbconfig_path, @dbconfig, acrecord)
      # mig.delete_migrate_config_and_db
      mig.delete_db
    end

    def rm_dbconfig
      dbconfig_path = @config.make_dbconfig_path(@dbconfig)
      #p dbconfig_path
      FileUtils.rm_f(dbconfig_path)
    end
  end
end

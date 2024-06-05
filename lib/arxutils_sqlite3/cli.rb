# frozen_string_literal: true

module Arxutils_Sqlite3
  # CLI用クラス
  class Cli
    def initialize(config, dbconfig, env, acrecord, yaml_fname, _mod)
      @config = config
      @dbconfig = dbconfig
      @env = env
      @acrecord = acrecord
      @dbconfig_path = @config.make_dbconfig_path(@dbconfig)

      @db_scheme_ary = nil
      if yaml_fname && yaml_fname.strip != ""
        yaml_pn = Pathname.new(yaml_fname)
        @db_scheme_ary = YAML.load_file(yaml_pn)
      end
      @mig = @config.prepare_for_migrate(@db_scheme_ary, @dbconfig_path, @dbconfig, @acrecord)
    end

    def setup(mod)
      # p "make_config_directory"
      @config.make_config_directory
      # p "setup_db_scheme_file"
      @config.setup_db_scheme_file(mod)
      # p "setup_opts_file(#{mod})"
      @config.setup_opts_file(mod)
      # p "setup_setting_yaml_file(#{mod})"
      @config.setup_setting_yaml_file(mod)
      # db_scheme_ary = nil
    end

    def copy_db_scheme
      # DBスキームファイルが存在しなければ、サンプルファイルをDBスキームファイルとしてコピー
      @config.copy_db_scheme_file
    end

    def copy_opts_file
      # optsファイルが存在しなければ、サンプルファイルをoptsファイルとしてコピー
      @config.copy_opts_file
    end

    def setup_for_migrate
      ret = :SUCCESS
      db_scheme_ary = nil
      dbconfig_path = @config.make_dbconfig_path(@dbconfig)
      # @config.check_file_exist(dbconfig_path, banner, exit_code)
      @config.prepare_for_migrate(db_scheme_ary, dbconfig_path, @dbconfig, @acrecord)
      ret
    end

    def makeconfig(opts)
      @mig.make_dbconfig(opts)
    end

    def make_migrate_script
      @dest_dbsetup_file = @config.dest_dbsetup_file
      @config.make_dbsetup_file(@db_scheme_ary, @acrecord, @mod, @dest_dbsetup_file)
      # マイグレーション用スクリプトの生成、acrecordのクラス定義ファイルの生成
      @mig.output
    end

    # マイグレーション実行
    def migrate
      # migrate用スクリプトの出力先ディレクトリ名
      migrate_dir = @config.migrate_dir

      # DB接続
      Arxutils_Sqlite3::Dbutil::Dbconnect.db_connect(@config, @dbconfig, @env)

      # マイグレーション実行
      # ActiveRecord::MigrationContext.new(migrate_dir, ActiveRecord::SchemaMigration).up
      ActiveRecord::MigrationContext.new(migrate_dir).up
    end

    def acr
      # DB接続
      connect_time = Arxutils_Sqlite3::Dbutil::Dbconnect.db_connect(@config, @dbconfig, @env)
      # `s` is a variable that is being used to store the value of the `gets` method.
      ret = :SUCCESS
      begin
        Dbsetup.new(connect_time)
      rescue StandardError => e
        puts e.message
        ret = :StandardError
      end

      ret
    end

    def clean
      @mig.delete_migrate_and_config_and_db
    end

    def delete
      @mig.delete_migrate_and_db
    end

    def delete_db
      @mig.delete_db
    end

    def delete_nigrate
      @mig.delete_migrate
    end

    def delete_setting_yaml
      FileUtils.rm_f(@config.setting_yaml_file)
    end

    def delete_migrate
      @mig.delete_migrate
    end

    def rm_dbconfig
      dbconfig_path = @config.make_dbconfig_path(@dbconfig)
      # p dbconfig_path
      FileUtils.rm_f(dbconfig_path)
    end
  end
end

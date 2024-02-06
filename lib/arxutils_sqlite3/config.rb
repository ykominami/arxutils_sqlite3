# frozen_string_literal: true

require "ykutils"

module Arxutils_Sqlite3
  ##
  # migrateに必要なファイルをテンプレートから作成し、migarteを実行する
  class Config
    # DB格納ディレクトリ名
    DB_DIR = "db"
    # migrate用スクリプト格納ディレクトリ名
    MIGRATE_BASE_DIR = "migrate"
    # SQLITE3用DB構成名
    DBCONFIG_SQLITE3 = "sqlite3"
    # MYSQL用DB構成名
    DBCONFIG_MYSQL = "mysql"
    # DB構成格納用ディレクトリ名
    CONFIG_DIR_NAME = "config"

    # コンフィグディレクトリへのパス
    CONFIG_DIR = Pathname.new(CONFIG_DIR_NAME)
    # データベース用ログファイル名
    DATABASELOG = "database.log"
    # テンプレートディレクトリへのパス
    TEMPLATE_DIR = Arxutils_Sqlite3::TOP_DIR.join("template")
    # リレーションテンプレートディレクトリへのパス
    TEMPLATE_ACRECORD_DIR = TEMPLATE_DIR.join("acrecord")
    TEMPLATE_CONFIG_DIR = TEMPLATE_DIR.join(CONFIG_DIR)
    DB_SCHEME_DIR = TEMPLATE_ACRECORD_DIR.join("db_scheme")
    DB_SCHEME_FILE = DB_SCHEME_DIR.join("db_scheme.yml")
    SAMPLE_DB_SCHEME_FILE = CONFIG_DIR.join("db_scheme.yml.sample")
    DB_SCHEME_FILE_NAME = "db_scheme.yml"
    DB_SCHEME_FILE_NAME_B = "db_scheme"
    OPTS_FILE_NAME = "opts.tmpl"
    SAMPLE_OPTS_FILE_NAME = "opts.rb.sample"
    OPTS_FILE_NAME_B = "opts"
    DEST_OPTS_FILE_NAME = "opts.rb"
    DEST_OPTS_FILE_NAME_B = "opts"
    DBSETUP_FILE_NAME = "dbsetup.tmpl"
    DBSETUP_FILE_NAME_B = "dbsetup"
    DEST_DBSETUP_FILE_NAME = "dbsetup.rb"
    SETTING_YAML_FILE_NAME = "setting.yml"
    DEST_CONFIG_DIR = Pathname.new(CONFIG_DIR)
    OPTS_FILE = DB_SCHEME_DIR.join(OPTS_FILE_NAME)
    SAMPLE_OPTS_FILE = CONFIG_DIR.join(SAMPLE_OPTS_FILE_NAME)
    # 変換先Dbsetupクラス定義のRubyスクリプトファイルへのパス
    DBSETUP_FILE = DB_SCHEME_DIR.join(DBSETUP_FILE_NAME)
    # 変換先optsファイル(Rubyスクリプトファイル)へのパス
    DEST_OPTS_FILE = DEST_CONFIG_DIR.join(DEST_OPTS_FILE_NAME)
    DEST_OPTS_FILE_B = DEST_CONFIG_DIR.join(OPTS_FILE_NAME_B)
    # 変換先Dbsetupクラス定義のRubyスクリプトファイルへのパス
    DEST_DBSETUP_FILE = DEST_CONFIG_DIR.join(DEST_DBSETUP_FILE_NAME)
    # 変換先Dbsetupクラス定義のRubyスクリプトファイル(拡張子無し)へのパス
    DEST_DBSETUP_FILE_B = DEST_CONFIG_DIR.join(DBSETUP_FILE_NAME_B)
    DEST_DB_SCHEME_FILE = DEST_CONFIG_DIR.join(DB_SCHEME_FILE_NAME)
    # 変換後DBスキームファイル(拡張子無し)へのパス
    DEST_DB_SCHEME_FILE_B = DEST_CONFIG_DIR.join(DB_SCHEME_FILE_NAME_B)
    SETTING_YAML_FILE = CONFIG_DIR.join(SETTING_YAML_FILE_NAME)
    DB_PN = Pathname.new(DB_DIR)
    # migrateディレクトリへのパス
    MIGRATE_DIR = DB_PN.join(MIGRATE_BASE_DIR)

    # 削除しないファイル群
    EXCLUDE_FILES = %w[SETTING_YAML_FILE_NAME].freeze
    # 作成対象のActiveRecordの子クラスのデフォルトクラス名
    DEFAULT_MOD = "Xenop"

    def default_mod
      DEFAULT_MOD
    end

    def setting_yaml_file
      SETTING_YAML_FILE
    end

    def dest_dbsetup_file_b
      DEST_DBSETUP_FILE_B
    end

    def setupx(toplevel)
      require_opts_file

      opts = toplevel.instance_variable_get(:@opts) || {}

      acrecord = opts[:acrecord]
      if acrecord
        filename = acrecord[:filename]
        basename = File.basename(filename)

        begin
          require basename.to_s
        rescue LoadError
          # pp ex.message
        end
      end
      opts[:db_dir] = Arxutils_Sqlite3::Config::DB_DIR

      setting = load_setting_yaml_file
      # p "setting=#{setting}"
      mod = setting[:mod]
      mod ||= DEFAULT_MOD

      # DBセットアップクラス
      require_dbsetup_file

      [opts, mod]
    end

    # DB構成ファイル格納ディレクトリの作成
    def make_config_directory
      # p "config make_config_directory"
      FileUtils.mkdir_p(CONFIG_DIR)
    end

    # DBスキームファイルのサンプルファイコピー
    def setup_db_scheme_file(mod)
      # p "config setup_db_scheme_file"
      # p "DB_SCHEME_FILE=#{DB_SCHEME_FILE}"
      # p "SAMPLE_DB_SCHEME_FILE=#{SAMPLE_DB_SCHEME_FILE}"
      scope = {}
      value_hash = { mod: mod }
      content = Ykutils::Erubyx.erubi_render_with_template_file(DB_SCHEME_FILE, scope, value_hash)
      # Ykxutils.yaml_load_compati(content)
      File.write(SAMPLE_DB_SCHEME_FILE, content)
    end

    # DBスキームファイルが存在しなければ、サンプルファイルをDBスキームファイルとしてコピー
    def copy_db_scheme_file
      return if File.exist?(DEST_DB_SCHEME_FILE)

      FileUtils.cp(SAMPLE_DB_SCHEME_FILE, DEST_DB_SCHEME_FILE)
    end

    # optsファイル(Rubyスクリプトファイル)のサンプルファイル書き込み
    def setup_opts_file(mod)
      scope = Object.new
      hash = { mod_name: mod }
      result_content = Ykutils::Erubyx.erubi_render_with_template_file(OPTS_FILE, scope, hash)
      File.write(SAMPLE_OPTS_FILE, result_content)
    end

    # optsファイルが存在しなければ、サンプルファイルをoptsファイルとしてコピー
    def copy_opts_file
      return if File.exist?(DEST_OPTS_FILE)

      # p "exist? #{File.exist?(DEST_OPTS_FILE)}"
      # p "copy SAMPLE_OPTS_FILE(#{SAMPLE_OPTS_FILE}) to DEST_OPTS_FILE(#{DEST_OPTS_FILE})"
      FileUtils.cp(SAMPLE_OPTS_FILE, DEST_OPTS_FILE)
    end

    # setting.ymlへの出力
    def setup_setting_yaml_file(mod)
      hash = { mod: mod }
      content = YAML.dump(hash)
      ret = :SUCCESS
      begin
        File.write(SETTING_YAML_FILE, content)
      rescue StandardError
        ret = :StandardError
      end
      ret
    end

    # DB構成ファイルの作成
    def make_dbconfig_path(dbconfig)
      # DB構成ファイル名
      Arxutils_Sqlite3::Util.make_dbconfig_path(CONFIG_DIR, dbconfig)
    end

    # optsファイル(Rubyスクリプトファイル)のrequire
    def require_opts_file
      return unless DEST_OPTS_FILE.exist?

      opts_file = File.join("./", DEST_OPTS_FILE_B.to_s)
      begin
        require opts_file
      rescue LoadError
        # pp ex.message
      end
    end

    # setting.ymlのロード
    def load_setting_yaml_file
      setting = {}
      # settingファイル
      setting_yaml_file = SETTING_YAML_FILE
      setting = YAML.load_file(setting_yaml_file) if setting_yaml_file.exist?
      setting
    end

    # Dbsetupファイル(Rubyスクリプトファイル)のrequire
    def require_dbsetup_file
      dbsetup_file = File.join(".", dest_dbsetup_file_b.to_s)
      begin
        require dbsetup_file
      rescue LoadError
        # pp ex.message
      end
    end

    # 指定ファイルの存在確認
    def check_file_exist(file_pn, banner, exit_code)
      return unless file_pn.exist?

      puts "#{file_pn} exists!"
      puts banner
      exit exit_code
    end

    # 指定ファイルの非存在確認
    def check_file_not_exist(file_pn, banner, exit_code)
      return if file_pn.exist?

      puts "#{file_pn} does not exists!"
      puts banner
      exit exit_code
    end

    # DB格納ディレクトリ名
    def db_dir
      DB_DIR
    end

    # migrateディレクトリへのパス
    def migrate_dir
      MIGRATE_DIR
    end

    # コンフィグディレクトリへのパス
    def config_dir
      CONFIG_DIR
    end

    # リレーションテンプレートディレクトリへのパス
    def template_acrecord_dir
      TEMPLATE_ACRECORD_DIR
    end

    # テンプレートディレクトリへのパス
    def template_config_dir
      TEMPLATE_CONFIG_DIR
    end

    # 変換先Dbsetupクラス定義のRubyスクリプトファイルへのパス
    def src_dbsetup_file
      DBSETUP_FILE
    end

    # 変換先Dbsetupクラス定義のRubyスクリプトファイルへのパス
    def dest_dbsetup_file
      DEST_DBSETUP_FILE
    end

    # DBログファイルの作成
    def setup_for_db_log_path(dbconfig)
      # DBログファイルへのパス
      Arxutils_Sqlite3::Util.make_log_path(db_dir, dbconfig)
    end

    # DB構成ファイルの作成
    def setup_for_dbconfig_path(dbconfig)
      # DB構成ファイル名
      Arxutils_Sqlite3::Util.make_dbconfig_path(config_dir, dbconfig)
    end

    # migrate用スクリプトの生成
    def make_migrate_script(db_scheme_ary, dbconfig_path, dbconfig, acrecord)
      mig = Arxutils_Sqlite3::Util.prepare_for_migrate(db_scheme_ary, dbconfig_path, dbconfig, acrecord)
      # マイグレーション用スクリプトの生成、acrecordのクラス定義ファイルの生成
      mig.output
    end

    # migrateの準備
    def prepare_for_migrate(db_scheme_ary, dbconfig_dest_path, dbconfig, acrecord)
      # DB構成ファイルの出力先ディレクトリ
      dbconfig_src_fname = "#{dbconfig}.tmpl"
      # migrate用スクリプトの出力先ディレクトリ名
      # migrate_dir = get_migrate_dir

      Migrate.new(
        self,
        dbconfig_dest_path,
        dbconfig_src_fname,
        db_scheme_ary,
        acrecord,
        migrate_dir
      )
    end

    def make_dbsetup_file(db_scheme_ary, acrecord, _mod, dest_dbsetup_file)
      scope = Object.new
      hash0 = { mod_name: acrecord[:module].join("::") }
      hash = db_scheme_ary[0].merge(hash0)
      result_content = Ykutils::Erubyx.erubi_render_with_template_file(src_dbsetup_file, scope, hash)

      File.write(dest_dbsetup_file, result_content)
    end

    def exclude_file?(fname)
      EXCLUDE_FILES.index(fname) != nil
    end
  end
end

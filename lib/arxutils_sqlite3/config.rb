require "ykutils"

module Arxutils_Sqlite3
  ##
  # migrateに必要なファイルをテンプレートから作成し、migarteを実行する
  class Config
    # DB格納ディレクトリ名
    DB_DIR = "db".freeze
    # migrate用スクリプト格納ディレクトリ名
    MIGRATE_BASE_DIR = "migrate".freeze
    # SQLITE3用DB構成名
    DBCONFIG_SQLITE3 = "sqlite3".freeze
    # MYSQL用DB構成名
    DBCONFIG_MYSQL = "mysql".freeze
    # DB構成格納用ディレクトリ名
    CONFIG_DIR_NAME = "config".freeze

    # コンフィグディレクトリへのパス
    CONFIG_DIR = Pathname.new(CONFIG_DIR_NAME)
    # データベース用ログファイル名
    DATABASELOG = "database.log".freeze
    # テンプレートディレクトリへのパス
    TEMPLATE_DIR = Arxutils_Sqlite3::TOP_DIR.join("template")
    # リレーションテンプレートディレクトリへのパス
    TEMPLATE_RELATION_DIR = TEMPLATE_DIR.join("relation")
    TEMPLATE_CONFIG_DIR = TEMPLATE_DIR.join( CONFIG_DIR )
    DB_SCHEME_DIR = TEMPLATE_RELATION_DIR.join("db_scheme")
    DB_SCHEME_FILE = DB_SCHEME_DIR.join("db_scheme.yml")
    DB_SCHEME_FILE_NAME = "db_scheme.yml".freeze
    DB_SCHEME_FILE_NAME_2 = "db_scheme".freeze
    OPTS_FILE_NAME = "opts.rb".freeze
    OPTS_FILE_NAME_2 = "opts".freeze
    DBSETUP_FILE_NAME = "dbsetup.rb".freeze
    DBSETUP_FILE_NAME_2 = "dbsetup".freeze
    SETTING_YAML_FILE_NAME = "setting.yml".freeze
    DEST_CONFIG_DIR = Pathname.new( CONFIG_DIR )
    OPTS_FILE = DB_SCHEME_DIR.join(OPTS_FILE_NAME)
    # 変換先Dbsetupクラス定義のRubyスクリプトファイルへのパス
    DBSETUP_FILE = DB_SCHEME_DIR.join(DBSETUP_FILE_NAME)
    # 変換先optsファイル(Rubyスクリプトファイル)へのパス
    DEST_OPTS_FILE = DEST_CONFIG_DIR.join(OPTS_FILE_NAME)
    DEST_OPTS_FILE_2 = DEST_CONFIG_DIR.join(OPTS_FILE_NAME_2)
    # 変換先Dbsetupクラス定義のRubyスクリプトファイルへのパス
    DEST_DBSETUP_FILE = DEST_CONFIG_DIR.join(DBSETUP_FILE_NAME)
    # 変換先Dbsetupクラス定義のRubyスクリプトファイル(拡張子無し)へのパス
    DEST_DBSETUP_FILE_2 = DEST_CONFIG_DIR.join(DBSETUP_FILE_NAME_2)
    DEST_DB_SCHEME_FILE = DEST_CONFIG_DIR.join(DB_SCHEME_FILE_NAME)
    # 変換後DBスキームファイル(拡張子無し)へのパス
    DEST_DB_SCHEME_FILE_2 = DEST_CONFIG_DIR.join(DB_SCHEME_FILE_NAME_2)
    SETTING_YAML_FILE = CONFIG_DIR.join(SETTING_YAML_FILE_NAME)
    DB_PN = Pathname.new(DB_DIR)
    # migrateディレクトリへのパス
    MIGRATE_DIR = DB_PN.join(MIGRATE_BASE_DIR)

    # DB構成ファイル格納ディレクトリの作成
    def make_config_directory
      FileUtils.mkdir_p(CONFIG_DIR)
    end

    # DBスキームファイルのひな型コピー
    def setup_db_scheme_file
      FileUtils.cp(DB_SCHEME_FILE,  DEST_DB_SCHEME_FILE)
    end

    # optsファイル(Rubyスクリプトファイル)のrequire
    def setup_opts_file(klass)
      scope = Object.new
      hash = {klass: klass}
      result_content = Ykutils::Erubyx.erubi_render_with_template_file(OPTS_FILE, scope, hash)
      File.open(DEST_OPTS_FILE, "w"){|file|
        file.write(result_content)
      }
    end

    # setting.ymlへの出力
    def setup_setting_yaml_file(klass)
      hash = { "klass": klass }
      content = YAML.dump(hash)
      File.open(SETTING_YAML_FILE, "w"){|file|
        file.write(content)
      }
    end

    # DB構成ファイルの作成
    def make_dbconfig_path(dbconfig)
      # DB構成ファイル名
      Arxutils_Sqlite3::Util.make_dbconfig_path(CONFIG_DIR, dbconfig)
    end

    # optsファイル(Rubyスクリプトファイル)のrequire
    def require_opts_file
      if DEST_OPTS_FILE.exist?
        opts_file = File.join("./" , DEST_OPTS_FILE_2.to_s)
        begin
          require opts_file
        rescue LoadError => ex
          pp ex.message
        end
      end
    end

    # setting.ymlのロード
    def load_setting_yaml_file
      setting = {}
      # settingファイル
      setting_yaml_file = SETTING_YAML_FILE
      if setting_yaml_file.exist?
        setting = YAML.load_file( setting_yaml_file )
      end
      setting
    end

    # Dbsetupファイル(Rubyスクリプトファイル)のrequire
    def require_dbsetup_file
      dbsetup_file = File.join(".", get_dest_dbsetup_file_2.to_s)
      begin
        require dbsetup_file
      rescue LoadError => ex
        pp ex.message
      end
    end

    # 指定ファイルの存在確認
    def check_file_exist(file_pn, banner, exit_code)
      if file_pn.exist?
        puts "#{file_pn} exists!"
        puts banner
        exit 10
      end
    end

    # 指定ファイルの非存在確認
    def check_file_not_exist(file_pn, banner, exit_code)
      if !file_pn.exist?
        puts "#{file_pn} does not exists!"
        puts banner
        exit 10
      end
    end
    
    # 変換先optsファイル(Rubyスクリプトファイル)へのパス
    def get_dest_opts_file
      DEST_OPTS_FILE
    end

    # DB格納ディレクトリ名
    def get_db_dir
      DB_DIR
    end

    # migrateディレクトリへのパス
    def get_migrate_dir
      MIGRATE_DIR
    end
    # コンフィグディレクトリへのパス
    def get_config_dir
      CONFIG_DIR
    end

    # リレーションテンプレートディレクトリへのパス
    def get_template_relation_dir
      TEMPLATE_RELATION_DIR
    end

    # テンプレートディレクトリへのパス
    def get_template_config_dir
      TEMPLATE_CONFIG_DIR
    end

    # 変換先Dbsetupクラス定義のRubyスクリプトファイルへのパス
    def get_src_dbsetup_file
      DBSETUP_FILE
    end

    # 変換先Dbsetupクラス定義のRubyスクリプトファイルへのパス
    def get_dest_dbsetup_file
      DEST_DBSETUP_FILE
    end

    # 変換先Dbsetupクラス定義のRubyスクリプトファイル(拡張子無し)へのパス
    def get_dest_dbsetup_file_2
      DEST_DBSETUP_FILE_2
    end

    # 変換後DBスキームファイル名(拡張子無し)
    def get_dest_db_scheme_file
      DEST_DB_SCHEME_FILE_2
    end

    # DBログファイルの作成
    def setup_for_db_log_path(dbconfig)
      db_dir = get_db_dir
      # DBログファイルへのパス
      Arxutils_Sqlite3::Util.make_log_path(db_dir, dbconfig)
    end

    # DB構成ファイルの作成
    def setup_for_dbconfig_path(dbconfig)
      config_dir = get_config_dir
      # DB構成ファイル名
      Arxutils_Sqlite3::Util.make_dbconfig_path(config_dir, dbconfig)
    end

    # migrate用スクリプトの生成
    def make_migrate_script(db_scheme_ary, dbconfig_path, dbconfig, relation)
      mig = Arxutils_Sqlite3::Util.prepare_for_migrate(db_scheme_ary, dbconfig_path, dbconfig, relation)
      # マイグレーション用スクリプトの生成、relationのクラス定義ファイルの生成
      mig.output
    end

    # migrateの準備
    def prepare_for_migrate(db_scheme_ary, dbconfig_dest_path, dbconfig, relation)
      #db_dir = config.DB_DIR
      db_dir = get_db_dir
      migrate_dir = get_migrate_dir
      # DB構成ファイルの出力先ディレクトリ
      dbconfig_src_fname = "#{dbconfig}.tmpl"
      mig = Migrate.new(
        self,
        dbconfig_dest_path,
        dbconfig_src_fname,
        db_scheme_ary,
        relation
        )
    end

    def make_dbsetup_file(db_scheme_ary, relation, klass, dest_dbsetup_file)
      src_dbsetup_file = get_src_dbsetup_file

      scope = Object.new
      hash0 = {module_name: relation[:module].join("::")}
      hash = db_scheme_ary[0].merge( hash0 )
      hash["klass"] = klass
      result_content = Ykutils::Erubyx.erubi_render_with_template_file(src_dbsetup_file, scope, hash)

      #p "################ dest_dbsetup_file=#{dest_dbsetup_file}"
      File.open(dest_dbsetup_file, "w"){|file|
        file.write(result_content)
      }
    end
  end
end
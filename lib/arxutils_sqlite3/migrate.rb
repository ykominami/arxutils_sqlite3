#require "arxutils_sqlite3"
require "ykutils"
require "fileutils"
#require "active_support"
require "active_record"
require "active_record/migration"
require "pp"

# ActiveRecord用ユーティリティモジュール
module Arxutils_Sqlite3
  ##
  # migrateに必要なファイルをテンプレートから作成し、migarteを実行する
  class Migrate
    # migrate用スクリプトファイル名の先頭の番号の間隔
    FILENAME_COUNTER_STEP = 10

    # migrateに必要なファイルをテンプレートから作成し、migarteを実行する
    def self.migrate(db_dir, src_config_dir, log_fname, migrate_dir, env, db_scheme_ary, dbconfig, opts)
      p "Migrate.migrate 1 class"
      log_file_name = format("%s-%s", dbconfig.to_s, log_fname)
      mig = Migratex.new(db_dir, migrate_dir, src_config_dir, dbconfig, env, log_file_name, opts)
      # DB構成情報の生成
      # dbconfigのテンプレートは内容が固定である。
      if  opts["migrate_cmd"] == "makeconfig"
        mig.make_dbconfig(opts)
        return
      end
      p "Migrate.migrate 2 class"

      output_script(mig, db_scheme_ary)
      content_array = make_content_array(mig, db_scheme_ary)
      # 複数形のクラス名を集める
      count_class_plurals = content_array.reject do |x|
        x[:need_count_class_plural].nil?
      end
      need_count_class_plural = count_class_plurals.map { |x| x[:need_count_class_plural] }

      # relationのmigrateが必要であれば、それをテンプレートファイルから作成して、スクリプトの内容として追加する
      if content_array.find { |x| !x.nil? }
        data_count = {
          count_classname: "Count",
          need_count_class_plural: need_count_class_plural
        }
        ary = content_array.collect { |x| x[:content] }.flatten
        count_content = mig.convert_count_class_relation(data_count, "relation_count.tmpl")
        ary.unshift(count_content)
        content_array = ary
      end
      p "Migrate.migrate 3"
      # relationのスクリプトを作成
      mig.output_relation_script(content_array, opts[:relation])

      #p "Migrate.migrate 4"
      #dbinit = mig.dbinit
      #p dbinit
      #p "Migrate.migrate 5"

      p "Migrate.migrate 4"
      mig.setup_for_migrate
      p "Migrate.migrate 5"
      mig.migrate
      p "Migrate.migrate 5 END"
    end

    # migrationのスクリプトをファイル出力する
    def self.output_script(mig, db_scheme_ary)
      # スキーマ設定配列から、migrate用のスクリプトを作成する
      db_scheme_ary.map { |x| mig.make_script_group(x) }.flatten(1).each_with_index do |data, index|
        idy = (index + 1) * FILENAME_COUNTER_STEP
        mig.output_script(idy, *data)
      end
    end

    # relationを表すクラス定義のファイルの内容を生成
    def self.make_content_array(mig, db_scheme_ary)
      # スキーマ設定配列から、relationのmigrate用のスクリプトの内容(ハッシュ形式)の配列を作成する
      relations = db_scheme_ary.map do |x|
        mig.make_relation(x, "count")
      end
      relations.select { |x| x.size.positive? }
    end

    # migrate用のスクリプトの内容をテンプレートから作成し、ファイルに出力し、migrateを実行する
    class Migratex
      # DB接続までの初期化を行うDbinitクラスのインスタンス
      #attr_reader :dbinit

      # migrate用のスクリプトの生成、migrateの実行を行うmigratexの生成
      def initialize(db_dir, migrate_base_dir, src_config_dir, dbconfig, env, log_fname, opts)
        # DB接続までの初期化を行うDbinitクラスのインスタンス
        @dbinit = Dbutil::Dbinit.new(db_dir, migrate_base_dir, src_config_dir, dbconfig, env, log_fname, opts)
        # 生成するDB構成情報ファイルパス
        @dbconfig_dest_path = @dbinit.dbconfig_dest_path
        # 参照用DB構成情報ファイル名
        @dbconfig_src_fname = @dbinit.dbconfig_src_fname

        # migrate用スクリプトの出力先ディレクトリ名
        @migrate_dir = @dbinit.migrate_dir
        # テンプレートファイル格納ディレクトリ名
        @src_path = Arxutils_Sqlite3::TEMPLATE_RELATION_DIR
        # 構成ファイル格納ディレクトリ
        @src_config_path = Arxutils_Sqlite3::TEMPLATE_CONFIG_DIR
      end

      # Countクラス用のrelationのスクリプトの内容に変換
      def convert_count_class_relation(data, src_fname)
        convert(data, @src_path, src_fname)
      end

      # テンプレートファイルからスクリプトの内容に変換
      def convert(data, src_dir, src_fname)
        arx = Arx.new(data, File.join(src_dir, src_fname))
        # 指定テンプレートファイルからスクリプトの内容に作成
        arx.create
      end

      # データベース構成ファイルをテンプレートから生成する
      def make_dbconfig(data)
        content = convert(data, @src_config_path, @dbconfig_src_fname)
        File.open(@dbconfig_dest_path, "w", { encoding: Encoding::UTF_8 }) do |f|
          f.puts(content)
        end
      end

      # 英子文字で表現したクラス名が、countを表していなければ、relationを
      # 英子文字で表現したクラス名が、countを表していれが、空のハッシュを返す
      # スキーマでbase, noitem以外のフィールドが指定されていれば、そのフィールドに対するrelationの設定の内容を返す
      def make_relation(data, count_classname_downcase)
        if data[:classname_downcase] == count_classname_downcase
          {}
        else
          # 指定フィールドのフィールド名に対応したテンプレートファイルを用いて、relation設定を作成
          data[:flist].each_with_object({ content: [], need_count_class: nil }) do |field_name, s|
            case field_name
            when "base", "noitem"
              name_base = "relation"
              # data[:relation]がnilに設定されていたら改めて空の配列を設定
              data[:relation] = [] unless data[:relation]
            else
              data[:count_classname_downcase] = count_classname_downcase
              name_base = "relation_#{field_name}"
              s[:need_count_class_plural] ||= data[:plural]
            end
            # テンプレートファイルからスクリプトの内容を作成
            content = convert(data, @src_path, "#{name_base}.tmpl")
            s[:content] << content
          end
        end
      end

      # スキーマ設定からmigarte用スクリプトの内容を生成
      def make_script_group(data)
        #p data
        data[:flist].map { 
          |kind| 
          [kind, 
            convert(data, @src_path, "#{kind}.tmpl"), 
            data[:classname_downcase]
            ] }
      end

      # migrationのスクリプトをファイル出力する
      def output_script(idy, kind, content, classname_downcase)
        additional = case kind
                     when "base", "noitem"
                       ""
                     else
                       kind
                     end
        fname = File.join(@migrate_dir, format("%03d_create_%s%s.rb", idy, additional, classname_downcase))
        File.open(fname, "w", **{ encoding: Encoding::UTF_8 }) do |f|
          f.puts(content)
        end
      end

      # relationのスクリプトをファイル出力する
      def output_relation_script(content_array, opts)
        dir = opts[:dir]
        fname = opts[:filename]
        fpath = File.join(dir, fname)
        File.open(fpath, "w") do |file|
          opts[:module].map { |mod| file.puts("module #{mod}") }
          content_array.map do |x|
            file.puts x
            file.puts ""
          end
          opts[:module].map { |_mod| file.puts("end") }
        end
      end

      
      # migrateを実行する
      def setup_for_migrate
        # データベース接続とログ設定
        Dbutil::DbMgr.setup(@dbinit)
      end
      # migrateを実行する
      def migrate
        p "Migratex#migrate 1"
        # ActiveRecord::Migrator.migrate(@migrate_dir ,  ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
        # ActiveRecord::Migrator.new.migrate(@migrate_dir ,  ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
        # ActiveRecord::Migrator.current_version
        db_migrate_dir = File.join(Dbutil::DB_DIR, Dbutil::MIGRATE_DIR)
        ActiveRecord::MigrationContext.new(db_migrate_dir, ActiveRecord::SchemaMigration).up
        # p ActiveRecord::Migrator.migration_paths
        # p ActiveRecord::Migrator.SchemaMigration
        # ActiveRecord::Migrator.new.migrate(@migrate_dir)
        p "Migratex#migrate 1 END"
      end
    end
  end
end

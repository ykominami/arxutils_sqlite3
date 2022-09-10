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
    attr_reader :migrate_dir
    # migrate用スクリプトファイル名の先頭の番号の間隔
    FILENAME_COUNTER_STEP = 10
    # DB接続までの初期化を行うDbinitクラスのインスタンス
    #attr_reader :dbinit

    # migrate用のスクリプトの生成、migrateの実行を行うmigratexの生成
    def initialize(
      dbconfig_dest_path,
      dbconfig_src_fname,
      migrate_dir,
      db_dir,
      db_scheme_ary,
      relation,
      opts)
      # DB格納ディレクトリ名
      @db_dir = db_dir
      # DB構成ファイルの出力先ディレクトリ
      @dest_config_dir = Arxutils_Sqlite3::Dbutil::CONFIG_DIR
      # 生成するDB構成情報ファイルパス
      @dbconfig_dest_path = dbconfig_dest_path
      # 参照用DB構成情報ファイル名
      @dbconfig_src_fname = dbconfig_src_fname

      # migrate用スクリプトの出力先ディレクトリ名
      @migrate_dir = migrate_dir
      # テンプレートファイル格納ディレクトリ名
      @src_path = Arxutils_Sqlite3::TEMPLATE_RELATION_DIR
      # 構成ファイル格納ディレクトリ
      @src_config_path = Arxutils_Sqlite3::TEMPLATE_CONFIG_DIR
      # データベーススキーマ定義配列
      @db_scheme_ary = db_scheme_ary
      # リレーション指定
      @relation = relation
      # オプション指定
      @opts = opts

      FileUtils.mkdir_p(@db_dir) if @db_dir
      FileUtils.mkdir_p(@migrate_dir) if @migrate_dir
      FileUtils.mkdir_p(@dest_config_dir)
    end

    # マイグレート用スクリプト、DB構成情報ファイル、DBファイルの削除
    def delete_migrate_config_and_db
      FileUtils.rm(Dir.glob(File.join(@migrate_dir, "*"))) if @migrate_dir
      FileUtils.rm(Dir.glob(File.join(@dest_config_dir, "*")))
      Dir.glob(File.join(@db_dir, "*")).each do |x|
        # puts x
        FileUtils.rm(x) if File.file?(x)
      end
    end

    # マイグレーション用スクリプトの生成、relationのクラス定義ファイルの生成、migrate実行
    def process
      # migrationのスクリプトをファイル出力する
      output_all_script

      # relationを表すクラス定義のファイルの内容を生成
      content_array = make_content_array
      # p "content_array=#{content_array}"
      # 複数形のクラス名を集める
      count_class_plurals = content_array.reject do |x|
        x[:need_count_class_plural].nil?
      end
      need_count_class_plural = count_class_plurals.map { |x| x[:need_count_class_plural] }
      # relationのmigrateが必要であれば、それをテンプレートファイルから作成して、スクリプトの内容として追加する
      if content_array.find { |x| !x.nil? }
        # p "####### 1"
        data_count = {
          count_classname: "Count",
          need_count_class_plural: need_count_class_plural
        }
        # p "data_count=#{data_count}"
        ary = content_array.collect { |x| x[:content] }.flatten
        count_content = convert_count_class_relation(data_count, "relation_count.tmpl")
        ary.unshift(count_content)
        content_array = ary
      end
      # relationのスクリプトを作成
      output_relation_script(content_array, @relation)
    end

    # migrationのスクリプトをファイル出力する
    def output_all_script
      # スキーマ設定配列から、migrate用のスクリプトを作成する
      @db_scheme_ary.map { |x| make_script_group(x) }.flatten(1).each_with_index do |data, index|
        idy = (index + 1) * FILENAME_COUNTER_STEP
        output_script(idy, *data)
      end
    end

    # relationを表すクラス定義のファイルの内容を生成
    def make_content_array
      # スキーマ設定配列から、relationのmigrate用のスクリプトの内容(ハッシュ形式)の配列を作成する
      relations = @db_scheme_ary.map do |x|
        make_relation(x, "count")
      end
      relations.select { |x| x.size.positive? }
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
      File.open(
        @dbconfig_dest_path, "w:utf-8") do |f|
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
      # pp "=="
      # pp opts
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
  end
end

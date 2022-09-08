#! -*- encoding : UTF-8 -*-

require "fileutils"
require "yaml"
require "active_record"
require "sqlite3"
require "ykxutils"

def require_x(path)
  require path
rescue StandardError => e
  p "1 request_x"
  p e
rescue LoadError => e
  p "21 request_x"
  p e
rescue NotImplementedError => e
  p "22 request_x"
  p e
rescue SyntaxError => e
  p "23 request_x"
  p e
rescue ScriptError => e
  p "20 request_x"
  p e
rescue Exception => e
  p "9 request_x"
  p e
end

module Arxutils_Sqlite3
  module Dbutil
    # DB操作用ユーティリティクラス
    class Dbconnect
      # 生成するDB構成情報ファイルパス
      attr_accessor :dbconfig_dest_path
      # 参照用DB構成情報ファイル名
      attr_accessor :dbconfig_src_fname
      # migrate用スクリプトの出力先ディレクトリ名
      attr_accessor :migrate_dir, :dest_config_dir, :db_dir

      def self.make_log_file_name(dbconfig, log_file_base_name)
        format("%s-%s", dbconfig.to_s, log_file_base_name)
      end

      # DB接続までの初期化に必要なディレクトリの確認、作成
      def initialize(db_dir, migrate_base_dir, src_config_dir, dbconfig, env, log_fname, opts)
        # 接続開始時刻
        @connect_time = nil
        # DB格納ディレクトリ名
        @db_dir = db_dir
        # DB構成ファイルのテンプレート格納ディレクトリ
        @src_config_dir = src_config_dir
        # DB構成ファイルの出力先ディレクトリ
        @dest_config_dir = CONFIG_DIR
        # DB構成ファイル名
        @dbconfig_dest_fname = "#{dbconfig}.yml"
        # DB構成ファイル用テンプレートファイル名
        @dbconfig_src_fname = "#{dbconfig}.tmpl"
        # DB構成ファイルへのパス
        @dbconfig_dest_path = File.join(@dest_config_dir, @dbconfig_dest_fname)
        # DB構成ファイル用テンプレートファイルへのパス
        @dbconfig_src_path = File.join(@src_config_dir, @dbconfig_src_fname)
        # 環境の指定
        @env = env
        # DB用ログファイル名
        @log_fname = log_fname

        if @db_dir && @log_fname
          # DB用ログファイルへのパス
          @log_path = File.join(@db_dir, @log_fname)
          # migrate用スクリプト格納ディレクトリへのパス
          @migrate_dir = File.join(@db_dir, migrate_base_dir)
        end
        FileUtils.mkdir_p(@db_dir) if @db_dir
        FileUtils.mkdir_p(@migrate_dir) if @migrate_dir
        FileUtils.mkdir_p(@dest_config_dir)
      end

      # DB接続、DB用ログファイルの設定
      def connect
        unless @connect_time
          begin
            dbconfig = Ykxutils.yaml_load_file_compati(@dbconfig_dest_path)
            ActiveRecord::Base.establish_connection(dbconfig[@env])
            ActiveRecord::Base.logger = Logger.new(@log_path)
            @connect_time = DateTime.now.new_offset
          rescue => ex
          end
        end
        @connect_time
      end
    end
  end
end

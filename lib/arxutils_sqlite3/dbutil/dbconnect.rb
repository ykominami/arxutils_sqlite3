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
      def self.make_log_file_name(dbconfig, log_file_base_name)
        format("%s-%s", dbconfig.to_s, log_file_base_name)
      end

      # DB接続までの初期化に必要なディレクトリの確認、作成
      def initialize(dbconfig_dest_path, env, log_path)
        # 接続開始時刻
        @connect_time = nil
        # DB格納ディレクトリ名
        @dbconfig_dest_path = dbconfig_dest_path
        @env = env
        @log_path = log_path
      end

      # DB接続、DB用ログファイルの設定
      def connect
        unless @connect_time
          begin
            p "@dbconfig_dest_path=#{@dbconfig_dest_path}"
            dbconfig = Ykxutils.yaml_load_file_compati(@dbconfig_dest_path)
            p "dbconfig=#{dbconfig}"
            p "@env=#{@env}"
            ActiveRecord::Base.establish_connection(dbconfig[@env])
            ActiveRecord::Base.logger = Logger.new(@log_path)
            @connect_time = DateTime.now.new_offset
          rescue => ex
            p ex.message
          end
        end
        @connect_time
      end
    end
  end
end

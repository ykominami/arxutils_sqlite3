#! -*- encoding : UTF-8 -*-
# frozen_string_literal: true

require "fileutils"
require "yaml"
require "active_record"
require "sqlite3"
require "ykxutils"

module Arxutils_Sqlite3
  module Dbutil
    # DB操作用ユーティリティクラス
    class Dbconnect
      def self.make_log_file_name(dbconfig, log_file_base_name)
        format("%s-%s", dbconfig.to_s, log_file_base_name)
      end

      def self.db_connect(config, dbconfig, env)
        # DB構成ファイルへのパス
        dbconfig_path = config.setup_for_dbconfig_path(dbconfig)
        # DB用ログファイルへのパス
        log_path = config.setup_for_db_log_path(dbconfig)
        # DB接続
        dbconnect = Arxutils_Sqlite3::Dbutil::Dbconnect.new(
          dbconfig_path,
          env,
          log_path
        )
        dbconnect.connect
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
            # p "@dbconfig_dest_path=#{@dbconfig_dest_path}"
            dbconfig, _value = Ykxutils.yaml_load_file_compati(@dbconfig_dest_path)
            # p "dbconfig=#{dbconfig}"
            # p "@env=#{@env}"
            # x =  dbconfig[@env]
            # p x 
            ActiveRecord::Base.establish_connection(dbconfig[@env])
            ActiveRecord::Base.logger = Logger.new(@log_path)
            @connect_time = DateTime.now.new_offset
          rescue StandardError => e
            p e.message
          end
        end
        @connect_time
      end
    end
  end
end

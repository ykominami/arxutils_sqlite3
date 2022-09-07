require "arxutils_sqlite3/dbutil/dbinit"
require "date"
require "pp"

module Arxutils_Sqlite3
  module Dbutil
    # DB接続時に、現在日時も取得したい場合のユーティリティクラス
    class DbMgr
      # DB接続の状態を示す
      @ret = nil
      # DB接続、現在日時取得
      def self.setup(dbinit)
        unless @ret
          begin
            dbinit.setup
            @ret = DateTime.now.new_offset
          rescue StandardError => e
            pp e.class
            pp e.message
            pp e.backtrace
          end
        end

        @ret
      end
    end
  end
end

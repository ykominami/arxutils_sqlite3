require "erb"
require "ykutils"

module Arxutils_Sqlite3
  # スキーマ設定に基づき、テンプレートから変換する
  class Arx
    @field = nil
    # スキーマ設定配列を、テンプレートで参照可能になるように展開する
    def initialize(data, fname)
      # テンプレートファイルへのパス
      @fname = fname

      # スキーマ設定配列
      # スキーマ設定とは以下をキーにもつハッシュである
      # :flist
      # :classname
      # :classname_downcase
      # :items
      #  フィールド名, 型, null許容 の配列
      # :plural
      # :acrecord
      @data = data

      # スキーマ設定の:itemsの値を展開後格納するためのStructクラス
      # @field ||= Struct.new("Field", :name, :type, :null)
      @field ||= Struct.new(:name, :type, :null)

      @data[:ary] = if @data[:items]
                      @data[:items].map { |x| @field.new(*x) }
                    else
                      []
                    end
    end

    # テンプレートファイルを元にした変換結果を返す
    def create
      scope = Object.new
      scope.instance_variable_set(:@data, @data)
      Ykutils::Erubyx.erubi_render_with_template_file(@fname, scope)
    end
  end
end

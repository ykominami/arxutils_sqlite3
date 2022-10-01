# frozen_string_literal: true

module Arxutils_Sqlite3
  # 階層処理
  class HierOp
    # 階層処理を付加したいフィールド名(未使用か？)
    attr_reader :field_name
    # '/'が区切り文字の文字列で階層処理を実現するクラスの階層構造を表す文字列を持つメソッド／アトリビュートを表すシンボル
    attr_reader :hier_symbol
    # '/'が区切り文字の文字列で階層処理を実現するクラスのクラス名(DB中のテーブルに対応するActiveRecordの子クラス)
    # シンボルhier_symbolで指定できるメソッド／アトリビュート(string)を持つ。
    # nameというメソッド／アトリビュート(string)を持つ。"'/'を区切り文字として持つ階層を表す文字列
    # registerメソッドを呼び出す時は、hier_symbolのみを指定してcreate出来なければならない（そうでなければSQLの制約違反発生）
    attr_reader :base_klass
    # '/'が区切り文字の文字列で階層処理を実現するクラスのカレントに対応するクラス名(DB中のテーブルに対応するActiveRecordの子クラス)
    attr_reader :current_klass
    # '/'が区切り文字の文字列で階層処理を実現するクラスのインバリッドに対応するクラス名(DB中のテーブルに対応するActiveRecordの子クラス)
    attr_reader :invalid_klass
    # IDの親子関係で階層処理を実現するクラス名(DB中のテーブルに対応するActiveRecordの子クラス)
    # parent_id(integer) , child_id(integer) , leve(integer)というメソッド／アトリビュートを持つ
    attr_reader :hier_klass

    # 初期化
    def initialize(field_name, hier_symbol, _hier_name, base_klass, hier_klass, current_klass, invalid_klass)
      # 階層処理を付加したいフィールド名
      @field_name = field_name
      # '/'が区切り文字の文字列で階層処理を実現するクラスの階層構造を表す文字列を持つメソッド／アトリビュートを表すシンボ
      @hier_symbol = hier_symbol
      # '/'が区切り文字の文字列で階層処理を実現するクラスのクラス名(DB中のテーブルに対応するActiveRecordの子クラス)
      @base_klass = base_klass
      # '/'が区切り文字の文字列で階層処理を実現するクラスのカレントに対応するクラス名(DB中のテーブルに対応するActiveRecordの子クラス)
      @current_klass = current_klass
      # '/'が区切り文字の文字列で階層処理を実現するクラスのインバリッドに対応するクラス名(DB中のテーブルに対応するActiveRecordの子クラス)
      @invalid_klass = invalid_klass
      # IDの親子関係で階層処理を実現するクラス名(DB中のテーブルに対応するActiveRecordの子クラス)
      #  print_id(integer), child_id(integer), level(integer)
      @hier_klass = hier_klass
    end

    # 指定した階層(階層を/で区切って表現)のアイテムをbase_klassから削除
    def delete(hier)
      # 子として探す
      id = nil
      base = @base_klass.find_by({ @hier_symbol => hier })
      if base
        delete_at(base.org_id)
        @base_klass.delete_at(base.id)
      end
      id
    end

    def delete_by_id(id)
      base = @base_klass.find_by(org_id: id)
      delete_at(id)
      @base_klass.delete_at(base.id)
    end

    # 文字列で指定した階層を移動
    def move(src_hier, dest_parent_hier)
      # dest_parent_hierがsrc_hierの子であれば(=src_hierがdest_parent_hierの先頭からの部分文字列である)何もせずエラーを返す
      escaped = Regexp.escape(src_hier)
      src_re = Regexp.new(%(^#{escaped}))
      ret = (src_re =~ dest_parent_hier)
      # 自身の子への移動はエラーとする
      return false if ret

      src_row_item = @base_klass.where(name: src_hier)
      src_num = src_row_item.id
      # srcが子である(tblでは項目を一意に指定できる)tblでの項目を得る
      src_row = @hire_klass.find_by(child_id: src_num)

      dest_parent_row_item = @base_klass.find_by(name: dest_parent_hier)
      dest_parent_num = if dest_parent_row_item
                          dest_parent_row_item.id
                        else
                          register(dest_parent_hier)
                        end
      dest_parent_level = get_level_by_child(dest_parent_num)

      # srcの親をdest_parentにする
      src_row.parent_id = dest_parent_num
      src_row.save
      # destに移動後のsrcの子のレベルを調整する
      level_adjust(src_row, dest_parent_level)
      # destに移動後のsrcのhierを再設定
      set_hier(src_row_item, make_hier(dest_parent_row_item.name, get_name(src_row_item)))
      src_row_item.save
      # destに移動後のsrcの子のhierを調整する
      hier_adjust(src_row_item)

      true
    end

    # 配列で指定した階層を親の階層としてhier_klassに登録
    def register_parent(hier_ary, child_num, level)
      hier_ary.pop
      parent_hier_ary = hier_ary
      parent_hier = parent_hier_ary.join('/')
      parent_num = register(parent_hier)
      hs = { parent_id: parent_num, child_id: child_num, level: level }
      @hier_klass.create(hs)
    end

    # 文字列で指定した階層(/を区切り文字として持つ)をhier_klassに登録
    def register(hier)
      hier_ary = hier.split('/')
      level = get_level_by_array(hier_ary)

      # もしhier_aryがnilだけを1個持つ配列、または空文字列だけを1個もつ配列であれば、hier_nameは空文字列になる
      item_row = @current_klass.find_by({ @hier_symbol => hier })
      if item_row
        new_num = item_row.org_id
        if level.zero?
          unless @hier_klass.find_by(child_id: new_num)
            hs = { parent_id: new_num, child_id: new_num, level: level }
            @hier_klass.create(hs)
          end
        else
          register_parent(hier_ary, new_num, level) unless @hier_klass.find_by(child_id: new_num)
        end
      else
        # @base_klassがhierだけでcreateできる場合は（他にフィールドがnot_nullでないか）、ここに来てもよい。
        # そうでなければ、SQLの制約違反が発生するため、ここに来ることを避けなければならない。
        # （あらかじめここが呼ばれないようにdatabaseに登録済みにしておかなければならない。）
        new_category = @base_klass.create({ @hier_symbol => hier })
        new_num = new_category.id
        if level.zero?
          unless @hier_klass.find_by(child_id: new_num)
            hs = { parent_id: new_num, child_id: new_num, level: level }
            @hier_klass.create(hs)
          end
        else
          register_parent(hier_ary, new_num, level)
        end
      end
      new_num
    end

    private

    # IDで指定した階層を削除
    def delete_at(num)
      # 子として探す
      hier = @hier_klass.find_by(child_id: num)
      level = hier.level
      parent_id = hier.parent_id
      # base = @base_klass.find_by(ord_id: num)

      # parent_base = @base_klass.find_by(ord_id: parent_id)
      # parent_hier_string = parent_base.__send__ @hier_symbol

      # 属する子を探す
      children_hier = @hier_klass.where(parent_id: num)
      # 属する子の階層レベルを調整する(削除するのでlevel - 1になる)
      children_hier.map { |x| level_adjust(x, level - 1) }
      # 属する子の親を、親の親にする
      children_hier.map do |x|
        x.parent_id = parent_id
        x.save
      end
      # 属する子のhierを調整する
      children_hier.map do |x|
        child_base = @base_klass.find_by(org_id: x.child_id)
        name = get_name(child_base)
        child_base.hier = make_hier(parent_hier, name)
        child_base.save
        hier_adjust(child_base)
      end
    end

    # 配列で指定した階層のレベルを得る
    def get_level_by_array(hier_ary)
      level = hier_ary.size - 1
      level = 0 if level.negative?
      level
    end

    # 階層を表すデータ構造から階層の名前を得る
    def get_name(items_row)
      items_row ? items_row.name.split('/').pop : ''
    end

    # 階層を表すデータ構造で指定された階層の下部階層の名前を調整する
    def hier_adjust(base)
      parent_hier_string = base.__send__ @hier_symbol
      parent_num = base.org_id

      tbl_rows = @hier_klass.where(parent_id: parent_num)
      return if tbl_rows.size.zero?

      tbl_rows.map do |x|
        child_num = x.child_id
        item_row = @base_klass.find_by(org_id: child_num)
        item_row.hier = make_hier(parent_hier_string, get_name(item_row))
        item_row.save
        hier_adjust(item_row)
      end
    end

    # 指定項目と、その子のlevelを調整
    def level_adjust(row, parent_level)
      row.level = parent_level + 1
      row.save
      child_rows = @hier_klass.where(parent_id: row.id)
      return if child_rows.size.zero?

      child_rows.map { |x| level_adjust(x, row.level) }
    end

    # IDで指定された階層のレベルを得る
    def get_level_by_child(num)
      @hier_klass.find_by(child_id: num).level
    end

    # 文字列で指定された親の階層の下の子の名前から、子の名前を作成
    def make_hier(parent_hier, name)
      [parent_hier, name].join('/')
    end
  end
end

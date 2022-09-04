module Arxutils_Sqlite3
  # 簡易的なトランザクション処理
  class TransactState
    # 対象ID群
    attr_reader :ids
    # 状態
    attr_accessor :state

    # 初期化
    def initialize
      # 対象ID群
      @ids = []
      # 状態
      @state = :NONE
    end

    # :TRACE状態の時のみ対象IDとして追加
    def add(xid)
      @ids << xid if @state == :TRACE
    end

    # 対象ID群をクリア
    def clear
      @ids = []
    end

    # 処理の必要性の確認
    def need?
      @ids.size.positive?
    end
  end

  # 複数の簡易的なトランザクション処理
  class TransactStateGroup
    # 初期化
    def initialize(*names)
      @names = names
      @state = :NONE
      @inst = {}
      names.map { |x| @inst[x] = TransactState.new }
    end

    # 処理の必要性の確認
    def need?
      @state != :NONE
    end

    # 状態の一括設定
    def set_all_inst_state
      @inst.map { |x| x[1].state = @state }
    end

    # 状態を:TRACEに一括設定
    def trace
      @state = :TRACE
      set_all_inst_state
    end

    # 状態を:NONEに一括設定
    def reset
      @state = :NONE
      set_all_inst_state
    end

    # 指定名の状態を返す
    def method_missing(name, _lang = nil)
      @inst[name]
    end

    # 指定名に対応するかを返す
    def respond_to_missing?(symbol)
      name = symbol.to_s
      @names.include?(name)
    end
  end
end

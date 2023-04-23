# frozen_string_literal: true

# ブラックジャックをコンソール上でプレイするプレイヤーを表現したクラス
class Player < Participant
  STRENGTH = {
    surrender: 0,
    burst: 1,
    stand: 3,
    black_jack: 4
  }.freeze

  RULE_MULTIPLIERS = {
    lose: 0,
    surrender: 0.5,
    push: 1,
    regular_win: 2,
    # double_down: 2,
    # split: 2,
    black_jack: 2.5
  }.freeze

  attr_accessor :chips, :bet_chips, :multiplier

  def initialize(name, chips)
    super(name)
    @chips = chips
    @bet_chips = 0
    @multiplier = RULE_MULTIPLIERS[:regular_win]
  end

  def reset_state
    super
    @name = 'あなた'
    @bet_chips = 0
    @multiplier = RULE_MULTIPLIERS[:regular_win]
  end
end

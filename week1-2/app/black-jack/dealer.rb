# frozen_string_literal: true

# ブラックジャックのディーラーを表現したクラス
class Dealer < Participant
  STRENGTH = {
    burst: 2,
    stand: 3,
    black_jack: 4
  }.freeze

  attr_accessor :deck, :hidden_card

  def initialize(name, rule, deck)
    super(name)
    @rule = rule
    @deck = deck
    @hidden_card = ''
  end

  def deal_card
    # TODO: Deckが無くなった場合の処理を追加
    @deck.draw_card
  end

  def burst_judge(total_score)
    @rule.burst?(total_score)
  end

  def stand_judge(total_score)
    @rule.stand?(total_score)
  end

  def reset_state
    super
    @hidden_card = ''
  end

  def reset_deck(new_deck)
    @deck = new_deck
  end
end

# frozen_string_literal: true

# ブラックジャックの参加者を表現したクラス
class Participant
  STRENGTH = {
    burst: 1,
    stand: 3,
    black_jack: 4
  }.freeze

  attr_accessor :name, :hand, :strength, :result

  def initialize(name)
    @name = name
    @hand = []
    @strength = 0
    @result = 0
  end

  def total_score
    @hand.sum(&:score)
  end

  def add_card(card)
    if card.rank == 'A'
      card.score = total_score + card.score > 21 ? 1 : 11
    end

    @hand.push(card)
  end

  def reset_state
    @hand.clear
    @strength = 0
    @result = 0
  end
end

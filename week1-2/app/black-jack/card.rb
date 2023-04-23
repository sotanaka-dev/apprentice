# frozen_string_literal: true

# ブラックジャックで使用するトランプカードを表現したクラス
class Card
  CARD_SCORE = {
    '2': 2, '3': 3, '4': 4, '5': 5, '6': 6, '7': 7, '8': 8, '9': 9, '10': 10, 'J': 10, 'Q': 10, 'K': 10, 'A': 11
  }.freeze

  SUITS = %w[ハート ダイヤ スペード クラブ].freeze
  RANKS = %w[A K Q J 10 9 8 7 6 5 4 3 2].freeze

  attr_accessor :suit, :rank, :score

  def initialize(suit, rank, score)
    @suit = suit
    @rank = rank
    @score = score
  end

  def to_label
    "#{@suit}の#{@rank}"
  end
end

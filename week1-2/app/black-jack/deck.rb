# frozen_string_literal: true

# ブラックジャックで使用するトランプのデッキを表現したクラス
class Deck
  attr_accessor :cards

  def initialize
    @cards = generate_cards
  end

  def generate_cards
    Card::SUITS.map do |suit|
      Card::RANKS.map do |rank|
        Card.new(suit, rank, Card::CARD_SCORE[rank.to_sym])
      end
    end.flatten.shuffle!
  end

  def draw_card
    @cards.pop
    # Card.new('スペード', 'A', 11)
  end
end

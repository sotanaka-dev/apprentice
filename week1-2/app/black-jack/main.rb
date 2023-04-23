# frozen_string_literal: true

require_relative 'game'
require_relative 'participant'
require_relative 'dealer'
require_relative 'player'
require_relative 'rule'
require_relative 'deck'
require_relative 'card'

game = Game.new
game.play

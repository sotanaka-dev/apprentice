# frozen_string_literal: true

# ブラックジャックの進行を管理するクラス
class Game
  # 参加者のインスタンスの初期化処理
  def initialize
    @player = Player.new('あなた', 100)
    @split_player = nil
    @dealer = Dealer.new('ディーラー', Rule.new, Deck.new)
    @cpu_player = generate_cpu_player
  end

  # メインルーチン
  def play
    puts 'ブラックジャックを開始します。'

    loop do
      set_bet_amount
      [@player, *@cpu_player, @dealer].each { |participant| deal_init_cards(participant) }
      player_turn
      [*@cpu_player, @dealer].each { |cpu| cpu_turn(cpu) }
      [@player, @split_player, *@cpu_player, @dealer].compact.each { |participant| display_score(participant) }
      [@player, @split_player, *@cpu_player].compact.each do |player|
        determine_winner(player)
        display_winner(player)
      end
      [@player, @split_player].compact.each { |player| calc_chips(player) }

      if yes?('もう一度プレイしますか？')
        reset_game
      else
        abort 'ブラックジャックを終了します。'
      end
    end
  end

  # 任意の数のCPUのプレイヤーを生成
  def generate_cpu_player
    print 'プレイ人数を選択してください。(3人まで) > '
    num_of_cpu_player = gets.chomp.to_i
    Array.new(num_of_cpu_player - 1) { |i| Participant.new("プレイヤー#{i + 2}") }
  end

  # ゲーム開始時のチップの設定
  def set_bet_amount
    puts "現在のチップは#{@player.chips}ドルです。"
    loop do
      print 'ベット額を10の倍数で入力してください。 > '
      bet_chips = gets.chomp.to_i

      if bet_chips > @player.chips
        puts 'チップが不足しています。'
      elsif bet_chips % 10 != 0
        puts '10の倍数を入力してください。'
      else
        @player.chips -= @player.bet_chips = bet_chips
        break
      end
    end
  end

  # 参加者にカードを2枚配る
  def deal_init_cards(participant)
    2.times do
      participant.add_card(@dealer.deal_card)
    end

    display_cards(participant)
  end

  # 最初に配られた2枚のカードを公開
  def display_cards(participant)
    puts "#{participant.name}の引いたカードは#{participant.hand[0].to_label}です。"

    if dealer?(participant)
      puts 'ディーラーの引いた2枚目のカードはわかりません。'
      participant.hidden_card = participant.hand[1]
    else
      puts "#{participant.name}の引いたカードは#{participant.hand[1].to_label}です。"
    end
  end

  # プレイヤーのターン
  def player_turn
    puts "#{@player.name}の現在の得点は#{@player.total_score}です。"
    loop do
      print 'ルールを選択してください。(1.このまま進める, 2.サレンダー, 3.ダブルダウン, 4.スプリット) > '
      select_rule = gets.chomp.to_i
      case select_rule
      when 1
        regular_player_turn(@player)
        break
      when 2
        surrender
        break
      when 3
        # TODO: チップ残高の確認が必要
        double_down
        break
      when 4
        # TODO: チップ残高の確認が必要
        if can_split?
          split
          break
        else
          puts 'スプリットできません。'
        end
      else
        puts '1~4を入力してください。'
      end
    end
  end

  # 特殊ルールを選択していない通常のプレイヤーのターン
  def regular_player_turn(player)
    loop do
      if yes?("#{player.name}の現在の得点は#{player.total_score}です。カードを引きますか？")

        participant_hit(player)

        if @dealer.burst_judge(player.total_score)
          player.strength = Player::STRENGTH[:burst]
          break
        end
      else
        player.strength = Player::STRENGTH[:stand]
        break
      end
    end
  end

  # サレンダーの処理
  def surrender
    puts "#{@player.name}はサレンダーを宣言しました。"
    @player.strength = Player::STRENGTH[:surrender]
    @player.multiplier = Player::RULE_MULTIPLIERS[:surrender]
  end

  # ダウブルダウンの処理
  def double_down
    puts "#{@player.name}はダブルダウンを宣言しました。"
    @player.chips -= @player.bet_chips
    @player.bet_chips *= 2

    participant_hit(@player)
    if @dealer.burst_judge(@player.total_score)
      @player.strength = Player::STRENGTH[:burst]
      return
    end
    @player.strength = Player::STRENGTH[:stand]
  end

  # スプリット可能な手札かを真偽値で返す
  def can_split?
    @player.hand[0].rank == @player.hand[1].rank
  end

  # スプリットの処理
  def split
    puts "#{@player.name}はスプリットを宣言しました。"

    @player.name = 'あなたの手札1'
    @split_player = Player.new('あなたの手札2', 0)
    @player.chips -= (@split_player.bet_chips = @player.bet_chips)
    @split_player.add_card(@player.hand.pop)

    [@player, @split_player].each do |player|
      player.add_card(@dealer.deal_card)
      regular_player_turn(player)
    end
  end

  # ヒットした際の処理
  def participant_hit(participant)
    dealt_card = @dealer.deal_card
    puts "#{participant.name}の引いたカードは#{dealt_card.to_label}です。"
    participant.add_card(dealt_card)
  end

  # CPUのターン（dealerは最後）
  def cpu_turn(cpu)
    puts "ディーラーの引いた2枚目のカードは#{@dealer.hidden_card.to_label}でした。" if dealer?(cpu)

    loop do
      if @dealer.burst_judge(cpu.total_score)
        cpu.strength = cpu.class::STRENGTH[:burst]
        break
      end

      if @dealer.stand_judge(cpu.total_score)
        cpu.strength = cpu.class::STRENGTH[:stand]
        break
      end

      puts "#{cpu.name}の現在の得点は#{cpu.total_score}です。"
      participant_hit(cpu)
    end
  end

  # 得点を表示
  def display_score(participant)
    puts "#{participant.name}の得点は#{participant.total_score}です。"
  end

  # ディーラーとプレイヤーの勝敗を決め、インスタンス変数に勝敗フラグをセット
  def determine_winner(player)
    result = 0

    %i[strength total_score].each do |member|
      result = player.send(member) <=> @dealer.send(member)
      break unless result.zero?
    end

    player.result = result
  end

  # ディーラーと比較したそれぞれのプレイヤーの勝敗を表示
  def display_winner(player)
    puts "ディーラーと#{player.name}の勝負は" \
    + case player.result
      when 1
        "#{player.name}の勝ちです。"
      when -1
        'ディーラーの勝ちです。'
      else
        '引き分けです。'
      end
  end

  # ベット額と比率でチップを計算
  def calc_chips(player)
    if player.result == -1 && player.strength != Player::STRENGTH[:surrender]
      player.multiplier = Player::RULE_MULTIPLIERS[:lose]
    end
    player.multiplier = Player::RULE_MULTIPLIERS[:push] if player.result.zero?

    @player.chips += (player.bet_chips * player.multiplier).to_i
  end

  # ユーザーの手札やデッキの内容をリセット
  def reset_game
    [@player, *@cpu_player, @dealer].each(&:reset_state)
    @split_player = nil
    @dealer.reset_deck(Deck.new)
  end

  # Dealerクラスのインスタンスかを真偽値で返す
  def dealer?(participant)
    participant.instance_of?(Dealer)
  end

  # yes or noを標準入力で受け取り、真偽値で返す
  def yes?(message)
    loop do
      print "#{message}（Y/N）"
      answer = gets.chomp.upcase

      case answer
      when 'Y'
        return true
      when 'N'
        return false
      else
        puts 'Y/Nを入力してください。'
      end
    end
  end
end

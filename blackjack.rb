# frozen_string_literal: true

# プレーヤーのカードを管理するクラス
class Hand
  def initialize
    @cards = []
  end

  def add_card(card)
    @cards << card
  end

  def calculate_total
    total = sum_of_card_values
    aces = count_aces

    while aces.positive? && total + 10 <= 21
      total += 10
      aces -= 1
    end

    total
  end

  def sum_of_card_values
    @cards.map { |card| card.to_hash[:number] }.sum
  end

  def count_aces
    @cards.count { |card| card.to_hash[:number] == 1 }
  end

  def current_cards
    @cards
  end

  def current_cards_to_name
    @cards.map.with_index { |card, index| "#{card.to_card_name}#{index.zero? ? 'と' : nil}" }.join('')
  end

  def cards_to_name_for_dealer
    @cards.first.to_card_name.to_s
  end
end

# ブラックジャック進行クラス
class BlackJack
  def initialize
    @player = Hand.new
    @dealer = Hand.new
  end

  def start
    deal_first_card_to_both
    deal_card_to_player
    deal_card_to_dealer if @player.calculate_total <= 21
    compare
  end

  def compare
    player_score = @player.calculate_total
    dealer_score = @dealer.calculate_total
    p "あなたの得点は#{player_score}です"
    p "ディーラーの得点は#{dealer_score}です"
    return p 'バーストしました！あなたの負けです' if player_score > 21
    return p 'あなたの勝ちです' if dealer_score > 21 || player_score > dealer_score

    p 'ディーラーの勝ちです'
  end

  def adjust_ace_value(score, cards)
    aces = cards.select { |card| card[:number] == 1 }
    aces.each do
      score += 10 if score + 10 <= 21
    end
    score
  end

  def deal_first_card_to_both
    2.times do
      @player.add_card(Card.new)
      @dealer.add_card(Card.new)
    end
    p "あなたの引いたカードは#{@player.current_cards_to_name}です"
    p "ディーラーの引いたカードは#{@dealer.cards_to_name_for_dealer}ともう一枚のカードはわかりません"
  end

  def deal_card_to_player
    while @player.calculate_total < 21
      p "あなたの現在の得点は#{@player.calculate_total}です。カードを引きますか？(y/n)"
      user_input = gets.chomp.downcase
      if user_input == 'y'
        @player.add_card(Card.new)
        p "あなたの引いたカードは#{@player.current_cards.last.to_card_name}です."
      end
      return if user_input == 'n'
    end
  end

  def deal_card_to_dealer
    @dealer.add_card(Card.new) while @dealer.calculate_total < 17
  end

  # カードの中身を決めるクラス
  class Card
    attr_reader :suit, :number
    SUITS = %w[ハート ダイヤ スペード クラブ].freeze
    NUMBERS = [2, 3, 4, 5, 6, 7, 8, 9, 'ジャック', 'クイーン', 'キング', 'A'].freeze
    def initialize
      @suit = SUITS.sample
      initial_number = NUMBERS.sample
      @number = case initial_number
                when 'ジャック', 'クイーン', 'キング'
                  10
                when 'A'
                  [1, 11].sample
                else
                  initial_number.to_i
                end
    end
    

    def to_card_name
      "#{@suit}の#{@number}"
    end

    def to_hash
      { suit: @suit, number: @number }
    end
  end
end

BlackJack.new.start

class Hand
  def initialize
    @cards = []
  end

  def add_card(card)
    @cards << card
  end

  def calculate_total
    total = 0
    aces = 0

    @cards.each do |card|
      total += card[:number]
      aces += 1 if card[:number] == 1
    end

    while aces > 0 && total + 10 <= 21
      total += 10
      aces -= 1
    end

    total
  end
  def current_cards
    @cards
  end
end

class BlackJack
  def initialize
    @player = Hand.new
    @dealer = Hand.new
  end

  def start 
    deal_first_card_to_both
    deal_card_to_player
    if @player.calculate_total <= 21
      deal_card_to_dealer
    end
    compare
  end

  def compare
    player_score = @player.calculate_total
    dealer_score = @dealer.calculate_total
    p "あなたの得点は#{player_score}です"
    p "ディーラーの得点は#{dealer_score}です"
    if player_score > 21
      p "バーストしました！あなたの負けです"
    elsif dealer_score > 21 || player_score > dealer_score
      p "あなたの勝ちです"
    else
      p "ディーラーの勝ちです"
    end
  end

  def adjust_ace_value(score, cards)
    aces = cards.select { |card| card[:number] == 1 }
    aces.each do
      if score + 10 <= 21
        score += 10
      end
    end
    score
  end

  def self.calculate_total(cards)
    total = 0
    aces = 0
    cards.each do |card|
      total += card[:number]
      aces = 1 if card[:number] == 1
    end
    while aces > 0 && total <= 21
      total += 10
      aces -= 1
    end
    total
  end

  def deal_first_card_to_both 
    @player.add_card(Card.random_card)
    @player.add_card(Card.random_card)
    @dealer.add_card(Card.random_card)
    @dealer.add_card(Card.random_card)

    player_cards = @player.current_cards
    dealer_cards = @dealer.current_cards
    p "あなたの引いたカードは#{player_cards[0][:suit]}の#{player_cards[0][:number]}と#{player_cards[1][:suit]}の#{player_cards[0][:number]}です"
    p "ディーラーの引いたカードは#{dealer_cards[0][:suit]}の#{dealer_cards[0][:number]}ともう一枚のカードはわかりません"
  end


  def deal_card_to_player
    while 21 > @player.calculate_total
      p "あなたの現在の得点は#{@player.calculate_total}です。カードを引きますか？(y/n)"
      user_input = gets.chomp 
      if user_input.downcase == "y"
        @player.add_card(Card.random_card)
        p "あなたの引いたカードは#{@player.current_cards.last[:suit]}の#{@player.current_cards.last[:number]}です."
      elsif user_input.downcase == "n"
        break
      else
        p "無効な入力です。カードを引きますか？(y/n)"
      end
    end
  end

  def deal_card_to_dealer
    while @dealer.calculate_total < 17
      @dealer.add_card(Card.random_card)
    end
  end

  class Card
    def self.random_card 
      suits = ["ハート","ダイヤ","スペード","クラブ"]
      numbers = [2,3,4,5,6,7,8,9,"ジャック","クイーン","キング","A"]
      suit = suits.sample
      number = numbers.sample

      number = case number
        when "ジャック","クイーン","キング" 
          number = 10
        when "A"
          [1,11].sample
        else number.to_i
        end

      {suit: suit, number: number}
    end
  end
end

BlackJack.new.start

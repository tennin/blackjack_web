require 'rubygems'
require 'sinatra'
require 'pry'

set :sessions, true

helpers do
  def total(cards)
  face_values = cards.map{|card|card[1]}
  total = 0
  face_values.each do |value|

      if value == 'ace'
          total = total + 11
      elsif value.to_i == 0
           total = total + 10
      else
           total = total + value.to_i
      end

    end

      if total > 21
            face_values.select{|v|v=='ace'}.count.times  do
            total = total - 10
      end
    end
   total
  end

  def location(card)
    #card.each do |card|
   "/images/cards/#{card[0]}_#{card[1]}.jpg"
#end
  end



end



get '/' do
  if session[:player_name]
    redirect '/game'
  else
    redirect '/new_player'
  end
end


get '/new_player' do
  erb :new_player

end

post '/new_player' do
  session[:player_name] = params[:username]
  redirect '/game'
end

post '/game/player/hit' do
  if session[:player_blackjack] == false  && total(session[:player_cards]) < 21
    session[:player_cards] << session[:deck].pop
  end

  redirect '/game/check'
end

post '/game/player/stay' do
  session[:player_turn] = false
  session[:dealer_turn] = true
  redirect '/game/check'
end

post '/game/dealer/hit' do
  if session[:dealer_blackjack] == false  && total(session[:dealer_cards]) < 17
    session[:dealer_cards] << session[:deck].pop


  end
  redirect '/game/check'
end


get '/game' do

  suits = ['spades', 'hearts', 'diamonds', 'clubs']
  values = ['ace','2','3','4','5','6','7','8','9','10','jack','queen','king']
  session[:deck] = suits.product(values).shuffle!

  session[:player_cards] = []
  session[:dealer_cards] = []

  session[:player_cards] << session[:deck].pop
  session[:dealer_cards] << session[:deck].pop
  session[:player_cards] << session[:deck].pop
  session[:dealer_cards] << session[:deck].pop
  session[:dealer_turn] = false
  session[:player_turn] = true
  session[:player_blackjack] = false
  session[:player_busted] = false
  session[:dealer_busted] = false
  session[:dealer_blackjack] = false


redirect '/game/check'

end

get '/game/check' do
  if total(session[:player_cards]) == 21
    session[:player_blackjack] = true
  elsif total(session[:player_cards]) > 21
    session[:player_busted] = true
  elsif total(session[:dealer_cards]) == 21
    session[:dealer_blackjack] = true
  elsif total(session[:dealer_cards]) > 21
    session[:dealer_busted] = true

  end




    erb :game
end




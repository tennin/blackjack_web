require 'rubygems'
require 'sinatra'
require 'pry'

set :sessions, true


def total(cards)

total = 0
cards.each do |card|
card.to_s

    if card[1] == 'ace'
        total = total + 11
     elsif card[1].to_i == 0
         ptotal = total + 10
      else
         total = total + card[1].to_i
     end

 end

   if total > 21
          cards.select{|v|v[1]=='ace'}.count.times  do
              total = total - 10
   end
 end
 total
 end






get '/' do
  if session[:player_name]
    redirect '/game'
  else
    redirect '/new_player'
  end

end


get '/new_player' do
erb :form

end

post '/new_player' do
  session[:player_name] = params[:username]
  redirect '/game'
end

post '/game/player/hit' do
if session[:player_busted] == false
session[:player_cards] << session[:deck].pop
end

erb :game

end

post '/game/player/stay' do
    session[:player_turn] = false
redirect '/game/dealer'

  end

get '/game/dealer' do

#if  blackjack_busted?

#else
  #  while total < 17
    #  hit
      #blackjack_busted?
   #   break
   # end
#end

erb :game
end


post '/game/dealer/hit' do
  if session[:dealer_busted] == false
  session[:dealer_cards] << session[:deck].pop
end
erb :game

end

  get '/game' do
session[:player_turn] = true
 session[:player_busted] = false
 session[:dealer_busted] = false
session[:dealer_total] = 0

  suits = ['spades', 'hearts','diamonds','clubs']
  values = ['ace','2','3','4','5','6','7','8','9','10','jack','queen','king']
  session[:deck] = suits.product(values).shuffle!

  session[:dealer_cards] = []
  session[:player_cards] = []

  session[:dealer_cards] << session[:deck].pop
  session[:player_cards] << session[:deck].pop
  session[:dealer_cards] << session[:deck].pop
  session[:player_cards] << session[:deck].pop

  erb :game
end







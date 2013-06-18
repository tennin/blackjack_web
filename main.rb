require 'rubygems'
require 'sinatra'
require 'pry'

set :sessions, true




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

post '/hit' do
if session[:player_busted] == false
session[:player_cards] << session[:deck].pop
end

erb :game

end

post '/stay' do

erb :game
  end


  get '/game' do


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
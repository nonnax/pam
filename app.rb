#!/usr/bin/env ruby
# Id$ nonnax 2022-04-06 17:16:12 +0800

require 'pam'
require 'json'

WATCHLIST='lib/watchlist.json'
TV='lib/tv-series.json'
MOVIES='lib/movies.json'

handle 404 do 
  res.write erb( '# Not Found')
end

get '/' do
  res.redirect '/reviews'
end

get '/tv' do |params|
  tvdata=JSON.load(File.read TV, symbolize_names: true)
  erb :watch, title: 'tv', data: tvdata
end

get '/movie' do
  moviedata=JSON.load(File.read MOVIES, symbolize_names: true)
  erb :watch, title: 'movie', data: moviedata
end

get '/watchlist' do
  watchdata=JSON.load(File.read WATCHLIST, symbolize_names: true)
  erb :watchlist, title: 'watchlist', data: watchdata
end

get '/save' do |params|
  text=File.read(WATCHLIST) rescue ""
  JSON.load(text)
  .then{|watchlist|
    watchlist||={}
    watchlist[params[:link]]=params
    File.write(WATCHLIST, watchlist.to_json)
  }
  res.redirect req.referer
end

get '/reviews' do 
  @name= 'ronald'
  erb :text
end

get '/about' do 
  erb :about, title: 'about'
end

pp Pam.map

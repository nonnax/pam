#!/usr/bin/env ruby
# Id$ nonnax 2022-04-06 17:16:12 +0800

require './lib/pam'
require 'json'

handle 404 do 
  res.write erb( '# Not Found')
end

get '/' do
  res.redirect '/reviews'
end

get '/reviews' do 
  @name= 'ronald'
  erb :text
end

get '/about' do 
  erb '#<%=locals[:title]%>', title: 'about', markdown: 1
end

pp Pam.map

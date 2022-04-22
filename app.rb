#!/usr/bin/env ruby
# Id$ nonnax 2022-04-06 17:16:12 +0800

require 'pam'
require 'json'

handle 404 do 
  res.write erb( '# Not Found')
end

get '/' do
  res.redirect '/reviews'
end

get '/reviews' do 
  erb :text
end

get '/about' do 
  erb '#<%=locals[:title]%>', title: 'about', markdown: nil
end

pp Pam.map

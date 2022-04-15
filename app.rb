#!/usr/bin/env ruby
# Id$ nonnax 2022-04-06 17:16:12 +0800
require_relative 'lib/pam'
# require 'pam'

# custom not found handler
handle 404 do
  erb '#Nothing here!'
end
 
get '/' do
  res.redirect '/tv'
end

get '/tv' do
  erb :tv, title: 'tee vee'
end

get '/mov' do
  erb :movie, title: 'moo vee'
end

get '/home' do
  # @items = map.keys.map(&:last).uniq
  erb :index
end

get '/text' do |params|
  erb :text
end

get '/r' do
  res.redirect '/text'
end

get '/plain' do |params|
  erb "plain text with query_string: #{params}" 
end

get '/name/:name' do params
  name='ronald'
  res.write ":template #{params}"
end

get '/watch/:id' do |params|
  erb params[:id].to_sym rescue res.redirect '/'
end

#!/usr/bin/env ruby
# Id$ nonnax 2022-04-06 17:16:12 +0800
require_relative 'lib/pam'

get '/' do
  @items = map.keys.map(&:last).uniq
  erb :index
end

get '/text' do 
  @name= 'ronald'

  erb "<%= params[:name] %>,this is text of: <%= self.name %>"
end

get '/r' do
  res.redirect '/text'
end

post '/text' do
  @name='ronald'
  erb :template
end

pp Pam.map
run Pam

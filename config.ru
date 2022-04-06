#!/usr/bin/env ruby
# Id$ nonnax 2022-04-06 17:16:12 +0800
require_relative 'lib/pam'
require 'rack/cache'

use Rack::Cache,
  metastore:    'file:/var/cache/rack/meta',
  entitystore:  'file:/var/cache/rack/body',
  verbose:      true
  
use Rack::Static,
    urls: %w[/images /js /css],
    root: 'public'

get '/' do
  @items = map.keys.map(&:last).uniq
  erb :index
end

get '/text' do 
  @name= 'ronald'

  erb :text
end

get '/r' do
  res.redirect '/text'
end

get '/plain' do
  "plain text with: #{params}" 
end

post '/text' do
  @name='ronald'
  erb :template
end

pp Pam.map
run Pam

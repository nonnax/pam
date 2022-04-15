#!/usr/bin/env ruby
# Id$ nonnax 2022-04-09 14:10:39 +0800
require 'sassc'
# sass=File.read(ARGV.first)
sass = ARGF.read
puts SassC::Engine.new(sass, style: :expanded).render
# :compressed, :compact, :nested, :expanded
# puts SassC::Engine.new(sass).render

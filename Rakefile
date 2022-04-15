#!/usr/bin/env ruby
# Id$ nonnax 2022-04-13 23:26:35 +0800
desc 'update'
task :update do
  mod_file = File.expand_path('views/tv.erb', __dir__)
  seconds_elapsed = (Time.now-File.mtime(mod_file)).to_i rescue 0
  if seconds_elapsed > 60*60*12 # 12-hrs
    sh './flixtor 1 tv'
    sh './flixtor 1 mov'
    sh './syncw.rb'
  end
end

desc 'compile style.scss'
task :compile do
  require 'sassc'
  css=nil
  Dir.chdir 'scss/' do
    sass=File.read('style.scss')
    css=SassC::Engine.new(sass, style: :compact).render
  end
  File.write 'public/css/style.css', css
  
end

desc 'rackup'
task run: %i[compile] do
  sh 'rackup'
end

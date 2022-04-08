#!/usr/bin/env ruby
# Id$ nonnax 2022-04-06 17:12:18 +0800
require 'kramdown'
require 'erb'

D=Object.method(:define_method)
module Pam
  maps=Hash.new{|h,k| h[k]=nil}
  D.(:map){ maps }
  D.(:res){ @res }
  D.(:req){ @req }
  D.(:params){ @params }
  # D.(:locals){ @locals }
  %w(GET POST PUT DELETE).map do |v|
    D.(v.downcase){|u, **opts, &b| 
       r={opts:, block: b }
       maps[[v, u]]=r unless u.match(/\./)
    }
  end
  def self.call(e)
    @req, @res=Rack::Request.new(e), Rack::Response.new
    res.headers['Content-type']='text/html; charset=utf-8'
    r=map.dup[e.values_at('REQUEST_METHOD', 'REQUEST_PATH')]
    @params=req.params.transform_keys(&:to_sym)
    body=instance_exec(req.params, &r[:block]) rescue nil
    res.write(body)
    res.status=404 unless r
    res.finish
  end
  def self.render(text, **opts, &block)
    b=binding
    b.local_variable_set(:locals, opts[:locals])
    ERB.new(text, trim_mode: '%').result(b)
  end

  D.(:erb) do |v, **locals|
    l, t=[:layout, v].map{|e| File.expand_path("views/#{e}.erb", Dir.pwd)}
    text=v.is_a?(Symbol) ? File.read(t) : v
    lout=File.read(l) #if File.exist?(l)
    render(text, **locals)
    .then{|text| Kramdown::Document.new(text).to_html }
    .then{|md| lout ? render(lout, **locals){md}:md }
  end
end


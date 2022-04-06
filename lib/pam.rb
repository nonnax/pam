#!/usr/bin/env ruby
# Id$ nonnax 2022-04-06 17:12:18 +0800
require 'pp'
require 'kramdown'

D=Object.method(:define_method)
module Pam
  maps=Hash.new{|h,k| h[k]={}}
  D.(:map){ maps }
  D.(:res){ @res }
  D.(:req){ @req }
  D.(:params){ @params }
  %w(GET POST PUT DELETE).map do |v|
    D.(v.downcase){|u,&b| maps[[v, u]]=b }
  end
  def self.call(e)
    @req=Rack::Request.new(e)
    @res=Rack::Response.new
    @params=req.params.transform_keys(&:to_sym)
    res.headers['Content-type']='text/html; charset=utf-8'
    b=map[e.values_at('REQUEST_METHOD', 'REQUEST_PATH')]
    body=instance_exec(req.params, &b) rescue nil
    res.write(body)
    res.status=404 unless b
    res.finish
  end
  def self.render(text, b=binding, &block)
    ERB.new(text, trim_mode: '%').result(b)
  end
  D.(:erb) do |v, **params|
    l, t=[:layout, v].map{|e| File.expand_path("../views/#{e}.erb", __dir__)}
    text=v.is_a?(Symbol) ? File.read(t) : v.to_s
    lout=File.read(l) if File.exist?(l)
    render(text)
    .then{|text| Kramdown::Document.new(text).to_html }
    .then{|md| lout ?render(lout){md}:md }
  end
end


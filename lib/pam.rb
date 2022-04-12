#!/usr/bin/env ruby
# Id$ nonnax 2022-04-06 17:12:18 +0800
%w(kramdown erb).map{|e| require e}
D=Object.method(:define_method)
class H<Hash; def self.[](*a) super.transform_keys!{|k| k.to_s.tr('.-','_').to_sym} end; end
module Pam
  class<<self; attr :res, :req, :env end
  maps, handlers = nil, nil # scope vars
  D.(:handler){ handlers ||= Hash.new{|h,k| h[k]=->(params){}} }
  D.(:map){ maps ||= Hash.new{|h,k| h[k]=nil} }
  D.(:halt){|r| throw :halt, r}
  D.(:handle){|n, &b| handler[n]=b}
  D.(:params){ req.params.transform_keys(&:to_sym) }
  D.(:finish!){ 
    instance_exec( params, &handler[res.status])
    res.finish
  }
  %w(GET POST PUT DELETE).map do |v|
    D.(v.downcase){|u, **opts, &b|  self.class.map[[v, u]]={opts:, block: b } unless u.match(/\./) }
  end
  def self.call(e)  
    @req, @res, @env=Rack::Request.new(e), Rack::Response.new, e
    res.headers['Content-type']='text/html; charset=utf-8'
    catch(:halt) do
      r=map.dup[e.values_at('REQUEST_METHOD', 'REQUEST_PATH')]
      r ? handler[200]=r[:block] : default
    end
    finish!
  end
  D.(:erb) do |v, **locals|
    l, t=[:layout, v].map{|e| File.expand_path("views/#{e}.erb", Dir.pwd)}
    text=v.is_a?(Symbol) ? IO.read(t) : v
    lout=IO.read(l) if File.exist?(l)
    render(text, **locals)
    .then{|text| Kramdown::Document.new(text).to_html }
    .then{|md| lout ? render(lout, **locals){md}:md }
    .then{|doc| res.write doc }
  end
  def self.render(text, **opts, &block)
    b=binding; b.local_variable_set(:locals, opts )
    ERB.new(text, trim_mode: '%').result(b)
  end
  D.(:default){res.status=404; throw(:halt, res) }
end


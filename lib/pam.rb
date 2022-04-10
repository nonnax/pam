#!/usr/bin/env ruby
# Id$ nonnax 2022-04-06 17:12:18 +0800
%w(kramdown erb).map{|e| require e}
D=Object.method(:define_method)
module Pam
  maps=Hash.new{|h,k| h[k]=nil}
  D.(:map){ maps }
  D.(:res){ @res }
  D.(:req){ @req }
  D.(:halt){|r| throw :halt, r}
  D.(:not_found){ res.write 'Not Found' } # override with def Pam.not_found(){[404, {}, ['??']]}
  D.(:params){ @params }
  %w(GET POST PUT DELETE).map do |v|
    D.(v.downcase){|u, **opts, &b|  maps[[v, u]]={opts:, block: b } unless u.match(/\./) }
  end
  def self.call(e)    
    @req, @res=Rack::Request.new(e), Rack::Response.new
    res.headers['Content-type']='text/html; charset=utf-8'
    catch(:halt) do
      r=map.dup[e.values_at('REQUEST_METHOD', 'REQUEST_PATH')]
      @params=req.params.transform_keys(&:to_sym)
      body=instance_exec(params, &r[:block]) rescue nil
      res.write(body)
      default unless r
    end
    res.finish
  end
  D.(:erb) do |v, **locals|
    l, t=[:layout, v].map{|e| File.expand_path("views/#{e}.erb", Dir.pwd)}
    text=v.is_a?(Symbol) ? IO.read(t) : v
    lout=IO.read(l) if File.exist?(l)
    render(text, **locals)
    .then{|text| Kramdown::Document.new(text).to_html }
    .then{|md| lout ? render(lout, **locals){md}:md }
  end
  def self.render(text, **opts, &block)
    b=binding; b.local_variable_set(:locals, opts )
    ERB.new(text, trim_mode: '%').result(b)
  end
  D.(:default){ res.status=404; throw(:halt, send(:not_found))  }
end


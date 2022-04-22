#!/usr/bin/env ruby
# Id$ nonnax 2022-04-06 17:12:18 +0800
# %w(response viewmd utils).map{|e| require_relative e}

D=Object.method(:define_method)
class H<Hash; def self.[](*a) super.transform_keys!{|k| k.to_s.tr('.-','_').to_sym} end; end
module Pam
  maps, handlers = nil, nil # scope vars
  D.(:map){ maps ||= Hash.new{|h,k| h[k]=[]} }
  D.(:handler){ handlers ||= Hash.new{|h,k| h[k]=->(params){ res.write 'Not Found' }} }
  D.(:handle){|n, &b| handler[n]=b}

  %w(GET POST PUT DELETE).map do |v| 
    D.(v.downcase){|path_info, **opts, &b|
      compiled_path, ext_params =  U(path_info).compile_path_params
      self.class.map[v]<<{path_info:, compiled_path:, ext_params:, opts:, block: b }  
    }  
  end
  def self.new
    Rack::Builder.new do
      use Rack::Static,
          urls: %w[/img /js /css],
          root: 'public'
      run App.new
    end
  end

  class App
    attr :res, :req, :env
    def call(e)  
      @req, @res, @env=Rack::Request.new(e), Pam::Response.new, e
      catch(:halt) do
        r=Pam::map.dup[req.request_method].detect{|e| e[:compiled_path].match?(req.path_info) }
        if r
          md=r[:compiled_path].match(req.path_info)
          req.params.merge! U(r[:ext_params]).zip_captures(md) #rescue {}      
          Pam::handler[res.status]=r[:block]
        else
          res.status=404
        end
        finish!
      end
    end
    def halt(r) throw :halt, r end
    def params() req.params.transform_keys(&:to_sym) end
    def finish!() instance_exec( params, &handler[res.status]); res.finish  end
    def default() res.status=404 end
  end
end




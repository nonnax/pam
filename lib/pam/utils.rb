#!/usr/bin/env ruby
# Id$ nonnax 2022-03-29 19:36:11 +0800
require 'uri'
require 'rack'

# decorator utils

# Any decorator util
# validity of methods depend on the `base` object passed to the `()` constructor
#
class U
  attr_accessor :base
  
  def initialize(base) @base=base end  
  # string decorators
  def clean_path_info() Rack::Utils.clean_path_info(base) end 
  
  def compile_path_params
    extra_params =  base.scan(/:(\w+)/).flatten.map(&:to_sym)
    compiled_path = base.gsub /:\w+/, '([^/?#]+)'
    [/^#{compiled_path}\/?$/, extra_params]
  end
  
   # array decorators 
  def zip_captures(matchdata) 
    base.zip(matchdata.captures).to_h rescue {} 
  end  

  # hash decorators  
  def keys_to_str() base.transform_keys{|k| k.to_s.split('_').map(&:capitalize).join('-')} end
  def keys_to_sym!() base.transform_keys!{|k| k.to_s.tr('-', '_').downcase.to_sym} end
  alias symbolize_keys keys_to_sym!  
  
  # Rack::Utils
  def self.method_missing(m, *a, **params, &b) Rack::Utils.send(m, *a, **params, &b) end
end

module Kernel
  def U(any) U.new(any) end
  def Q(s)   Q.new(s)   end
end

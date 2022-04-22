
module Pam
  module Viewmd
    define_method(:erb) do |v, **locals|
      pp locals
      l, t=[:layout, v].map{|e| File.expand_path("views/#{e}.erb", Dir.pwd)}
      text=v.is_a?(Symbol) ? IO.read(t) : v
      lout=IO.read(l) if File.exist?(l)
      render(text, **locals)
      .then{|text| locals[:markdown] ? text : Kramdown::Document.new(text).to_html }
      .then{|md| lout ? render(lout, **locals){md}:md }
      .then{|doc| res.html doc }
    end
    def render(text, **opts, &block)
      b=binding; b.local_variable_set(:locals, opts )
      ERB.new(text, trim_mode: '%').result(b)
    end    
  end
  class App
    include Viewmd
  end
end

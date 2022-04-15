#!/usr/bin/env ruby
# Id$ nonnax 2022-04-15 17:26:56 +0800
module Pam
  class Response < Rack::Response
    def json(**h)
      self.headers[Rack::CONTENT_TYPE]='application/json'
      h.to_json
      self.write h.to_json
    end
    def html(s)
      self.headers[Rack::CONTENT_TYPE]='text/html; charset=utf-8'
      self.write s
    end
  end
end

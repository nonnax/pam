#!/usr/bin/env ruby
# Id$ nonnax 2022-04-06 17:16:12 +0800
require_relative 'app'

use Rack::Static,
    urls: %w[/img /js /css],
    root: 'public'


pp Pam.map
run Pam


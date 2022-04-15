#!/usr/bin/env bash
# Id$ nonnax 2022-04-09 15:06:42 +0800
paste <(expand "$1") <(expand "$1" | ./sass.rb ) | expand --tabs=50 | bat -l scss -p 
# paste <(cat  standard.sass) <(expand standard.sass | ./sass.rb | bat -)  | expand --tabs=50

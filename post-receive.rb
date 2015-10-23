#!/usr/bin/env ruby

require 'colorize'

puts "Kicking off deployment...".yellow

`ps aux | grep 'open_call_server' | grep -v grep | awk '{print $2}'`.split(/\n/).each {|i| Process.kill 'TERM', i.to_i}

Dir.chdir "/Users/fdibartolo/Documents/RubyWorkspace/agiles2015/open_call/open_call_server"
if system("unset GIT_DIR && git pull origin master") and system("bundle install")
  puts "Updates pulled and bundled!".yellow
else
  puts "Something went wrong, reverting to previous version...".red
  system "git reset --hard"
end

puts "Starting app...".yellow
puts "App started!".green.bold if system("nohup bin/start &>/dev/null &")

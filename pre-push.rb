#!/usr/bin/env ruby

require 'colorize'
require 'json'

print "Running specs ".yellow

progress = fork { while true do print '='.yellow; $stdout.flush; sleep 0.1 end }

system "foreman run bin/rspec spec/mailers &>/dev/null"
Process.kill 'TERM', progress

unless $?.success?
  puts "\nUnable to push, some specs are failing!".red 
else
  coverage_threshold = 69
  result = JSON.parse File.open('coverage/.last_run.json').read
  if result['result']['covered_percent'] < coverage_threshold
    puts "\nUnable to push, code coverage is currently at #{result['result']['covered_percent']}! (must be above #{coverage_threshold})".red
    exit 1
  else
    puts " Ok!".green
  end
end

exit $?.exitstatus

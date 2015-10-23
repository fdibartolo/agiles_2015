#!/usr/bin/env ruby

require 'rubocop'
require 'colorize'

puts "Running code analysis...".yellow
files = `git status --porcelain`.split(/\n/).
  map { |f| f.split(' ')[1] }.
  select { |f| File.extname(f) == '.rb'}.join(' ')

system("rubocop #{files} -f json -o rubocop.json") unless files.empty?

unless $?.success?
  result = JSON.parse File.open('rubocop.json').read
  puts "#{result['summary']['offense_count']} offenses has been detected!\nExtra info within rubocop.json".red 
else
  puts "Ok!".green
end

exit $?.exitstatus

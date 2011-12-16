#!/usr/bin/env ruby
require "rubygems"
require "twitter"
require 'google_chart'

screen_name = String.new ARGV[0]

tweetsource = Hash.new

timeline = Twitter.user_timeline(screen_name, :count => 200 )
timeline.each do |t|

  if (t.source.rindex('blackberry')) then
    src = 'Blackberry'
  elsif (t.source.rindex('snaptu')) then
    src = 'Snaptu'
  elsif (t.source.rindex('tweetmeme')) then
    src = 'Tweetmeme'
  elsif (t.source.rindex('android')) then
    src = 'Android'
  elsif (t.source.rindex('LinkedIn')) then
    src = 'LinkedIn'
  elsif (t.source.rindex('twitterfeed')) then
    src = 'Twitterfeed'
  elsif (t.source.rindex('twitter.com')) then
    src = 'Twitter.com'
  else
    src = t.source
  end

  if tweetsource.has_key?(src)
    tweetsource[src] = tweetsource[src] + 1
  else
    tweetsource[src] = 1
  end

end

GoogleChart::PieChart.new('320x200', "Tweet Source", false) do |pc|

  tweetsource.each do|source,count|
    pc.data source.to_s, count
  end

  puts "\nPie Chart"
  puts pc.to_url

end

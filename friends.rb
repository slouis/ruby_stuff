#!/usr/bin/env ruby
require "rubygems"
require "twitter"
require 'google_chart'

name = String.new ARGV[0]

user = Hash.new

# Iterate friends, hash their followers
friends = Twitter.friend_ids(name)

friends.ids.each do |fid|

  f = Twitter.user(fid)

  # Only iterate if we can see their followers
  if (f.protected.to_s != "true")
    user[f.screen_name.to_s] = f.followers_count
  end

end

user.sort_by {|k,v| -v}.each { |user, count| puts "#{user}, #{count}" }

#!/usr/bin/env ruby
require "rubygems"
require "twitter"
require 'google_chart'

# -------------------------------------------------------------
def load_properties(properties_filename)
   properties = {}
   File.open(properties_filename, 'r') do |properties_file|
     properties_file.read.each_line do |line|
       line.strip!
       if (line[0] != ?# and line[0] != ?=)
         i = line.index('=')
         if (i)
           properties[line[0..i - 1].strip] = line[i + 1..-1].strip
         else
           properties[line] = ''
         end
       end
     end      
   end
   properties
 end
# -------------------------------------------------------------
props = load_properties('properties.properties')

screen_name = String.new ARGV[0]
tweetlocation = Hash.new
timezones = 0.0

# Authenticate
Twitter.configure do |config|
  config.consumer_key = props['consumer_key']
  config.consumer_secret = props['consumer_secret']
  config.oauth_token = props['oauth_token']
  config.oauth_token_secret = props['oauth_token_secret']
end

cursor = "-1"

# Loop through all pages
while cursor != 0 do

  # Iterate followers, hash their location
  followers = Twitter.follower_ids(screen_name, :cursor=>cursor)

  followers.ids.each do |fid|

    f = Twitter.user(fid)

    loc = f.time_zone.to_s

    if (loc.length > 0)

      if tweetlocation.has_key?(loc)
        tweetlocation[loc] = tweetlocation[loc] + 1
      else
        tweetlocation[loc] = 1
      end

      timezones = timezones + 1.0

    end

  end

  cursor = followers.next_cursor

end

# Create a pie chart
GoogleChart::PieChart.new('650x350', "Time Zones", false ) do |pc|

  tweetlocation.each do |loc,count|
    pc.data loc.to_s.delete("&"), (count/timezones*100).round
  end

  puts pc.to_url

end


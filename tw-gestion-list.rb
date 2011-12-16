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
tweetsource = Hash.new

# Authenticate
Twitter.configure do |config|
  config.consumer_key = props['consumer_key']
  config.consumer_secret = props['consumer_secret']
  config.oauth_token = props['oauth_token']
  config.oauth_token_secret = props['oauth_token_secret']
end

client = Twitter::Client.new

# Get your rate limit status
puts client.rate_limit_status.remaining_hits.to_s + " Twitter API request(s) remaining this hour"


#puts client.list_create("Following Paris", :mode=>"private")

#puts client;

list_from = "42835967";
list_to = 44200250;


client.lists.lists.each do |lis|
  puts lis.name + " : " + lis.id_str;
  if lis.id_str == list_from then
    puts "Début de la recopie";
    cursor = "-1"
    #puts client.list_members(lis.id).users.first;
    while cursor != 0 do
      members = client.list_members(lis.id, :cursor=>cursor)
      members.users.each do |member|
        begin
          if not client.list_member?(list_to, member.id) then
            newlist = client.list_add_member(list_to, member.id);
            puts newlist.member_count;
          end
        rescue
          puts member;
        end
      end
    cursor = members.next_cursor
    end
  end
end
   

#followings = client.friend_ids(screen_name)
#puts "Dernieres mise à jour " + Twitter.user(followings.ids.first).status.created_at;

#followings.ids.each do |fid|
#  f = client.user(fid)
#  begin
#    puts f.name + ";;" + f.status.created_at;
#  rescue
#    puts f.name + ";;";
#  end
#end

# Who's your most popular friend?
#puts client.friends.sort{|a, b| a.followers_count <=> b.followers_count}.reverse.first.name

# Who's your most popular follower?
#puts client.followers.sort{|a, b| a.followers_count <=> b.followers_count}.reverse.first.name



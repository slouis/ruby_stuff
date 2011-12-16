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

screen_name = String.new ARGV[0] if not ARGV[0].nil?
tweetsource = Hash.new

# Authenticate
Twitter.configure do |config|
  config.consumer_key = props['consumer_key']
  config.consumer_secret = props['consumer_secret']
  config.oauth_token = props['oauth_token']
  config.oauth_token_secret = props['oauth_token_secret']
end

output = ""

client = Twitter::Client.new

# Get your rate limit status
puts client.rate_limit_status.remaining_hits.to_s + " Twitter API request(s) remaining this hour"

# Initialize a Twitter search
#search = Twitter::Search.new

# Find the 3 most recent marriage proposals to @justinbieber
#search.containing("marry me").to("justinbieber").result_type("recent").per_page(3).each do |r|
#  puts "#{r.from_user}: #{r.text}"
#end

# Enough about Justin Bieber
#search.clear

# Let's find a Japanese-language status update tagged #ruby
#count = 0;
#puts "debut req1";
#tmp = search.since_date("2011-11-01").hashtag("paris").no_retweets.per_page(100).fetch;
#count = tmp.length;
#puts "fin req1"
#while search.next_page? do
#  tmp = search.fetch_next_page
#  count += tmp.length;
  #puts count;
#end
#puts count;
#recherche = search.hashtag("ruby").language("fr").no_retweets.per_page(1).fetch.first;
#puts recherche.from_user + " > " + recherche.text

# And another
#puts search.fetch_next_page.first.text


#puts client.list_create("Following Paris", :mode=>"private")

#puts client;

#list_from = "42835967";
#list_to = 44200250;


#client.lists.lists.each do |lis|
#  puts lis.name + " : " + lis.id_str;
#  if lis.id_str == list_from then
#    puts "Début de la recopie";
#    cursor = "-1"
#    #puts client.list_members(lis.id).users.first;
#    while cursor != 0 do
#      members = client.list_members(lis.id, :cursor=>cursor)
#      members.users.each do |member|
#        begin
#          if not client.list_member?(list_to, member.id) then
#            newlist = client.list_add_member(list_to, member.id);
#            puts newlist.member_count;
#          end
#        rescue
#          puts member;
#        end
#      end
#    cursor = members.next_cursor
#    end
#  end
#end
   

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




unFollow = { true => 'Yes', false => 'No' }

#output = client.followers.to_str;
contents = File.open('output.txt', 'rb') { |file| file.read }
#puts contents.split("#").map;

File.open("output.txt", "w+") do |out|

  
  cursor = "-1"
  # Loop through all pages
  while cursor != 0 do

    # Iterate followers, hash their location
    followers = Twitter.follower_ids(screen_name, :cursor=>cursor)
    followerto_s = followers.ids.map { |x| x.to_s }
    #puts followers.ids;
    current = followerto_s.partition {|fid| contents.split("#").include?(fid) }
    histo = contents.split("#").partition {|id| not followerto_s.include?(id) }
    etaientDejaLa = current.first;
    nouveaux = current.drop(1).first;
    partants = histo.first;

    puts "Deja la : " + etaientDejaLa.map { |id| Twitter.user(id.to_i).to_s }.inspect;
    puts "Nouveaux : " + nouveaux.inspect.to_s;
    puts "Partants : " + partants.map { |id| Twitter.user(id).to_s }.inspect;
    
    #puts "Nouveau follower : " + contents.split("#").grep(followers.ids).to_s;
    followerto_s.each do |fid|
      #f = Twitter.user(fid)
         #out << f.to_s
         #puts Twitter.friendship(:source_screen_name => "sebastien_louis", :target_id => fid)
         out << fid + "#";
         #puts "Ancien follower : " + 
         #puts "Nouveau follower : " + fid.to_s if not contents.split("#").include?(fid.to_s);
    end
    cursor = followers.next_cursor

  end
end

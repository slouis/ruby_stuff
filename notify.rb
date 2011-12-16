require "rubygems"
require "prowl"

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

appli = String.new ARGV[0]
msg = String.new ARGV[1]
description = String.new ARGV[2] unless ARGV[2].nil?

p = Prowl.new(:apikey => props['prowl_apikey'], :application => appli);
p.add(:event => msg, :description => description);

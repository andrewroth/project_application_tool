puts "This is a ruby svn update wrapper script, to set fix permissions only on updated files."
puts
puts "Doing an svn update in the background now..."

svnresults = %x[svn up]
files = svnresults.split("\n").collect{ |r| r =~ /^[AUGC]\W+(.*)/; $1 }.compact

puts "Output from svn: "
puts svnresults

puts "Now fixing permissions.."
for file in files
  puts file
  system "chgrp spt.campusforchrist.org #{file}"
end

puts "\nDone.\n"

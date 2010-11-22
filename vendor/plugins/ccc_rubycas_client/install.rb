require 'fileutils'
puts "Copying configuration..."
dest_dir = File.join(RAILS_ROOT, 'config', 'initializers')
FileUtils.mkdir_p(dest_dir)
dest_file = File.join(dest_dir, 'cas.rb')
src_file = File.join(File.dirname(__FILE__), 'config.rb')
FileUtils.cp(src_file, dest_file) unless File.exist?(dest_file)

puts "File copied - Installation complete!"

puts IO.read(File.join(File.dirname(__FILE__), 'QUICKSTART'))
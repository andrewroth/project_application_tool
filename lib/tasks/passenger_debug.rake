# add this rake file to your lib/tasks folder
task :restart do
  system("touch tmp/restart.txt")
  system("touch tmp/debug.txt") if ENV["DEBUG"] == 'true'
end

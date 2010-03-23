task :cleanup do
  Rake::Task["tmp:sessions:clear"].execute
  Rake::Task["tmp:cache:clear"].execute
end

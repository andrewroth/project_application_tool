require 'fileutils'

task :hudson => [ "test:mh_common:lock" ] do
  begin
    Rake::Task["db:test:prepare:all"].execute
    Rake::Task["spec:rcov"].execute
    FileUtils.mv "aggregate.data", "coverage/aggregate.data"
  rescue
    $logger.info "In rescue block"
    raise
  ensure
    Rake::Task["test:mh_common:lock:release"].execute
  end
end

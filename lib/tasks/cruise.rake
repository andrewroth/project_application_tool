class CustomLogger < Logger
  def format_message(severity, timestamp, progname, msg)
    "#{msg}\n"
  end
end

namespace :cruise do
  task :prepare => :environment do
    $logfile = File.open(Rails.root.join("log/cruise.log"), "a")
    $logfile.sync = true
    $logger = CustomLogger.new($logfile)
    $logger.info "Starting #{Time.now}"
    $lock_path = File.expand_path("~/.cruise/mh_common_lock")
    while File.exists?($lock_path)
      $logger.info "Detected another test going on.  Waiting 30 seconds."
      sleep 30
    end
    $lock = File.open($lock_path, "w")
    $logger.info "Established mh_common lock"
  end
end

task :cruise => [ "cruise:prepare" ] do
  begin
    Rake::Task["spec:rcov"].execute
  rescue
    $logger.info "In rescue block"
    raise
  ensure
    $logger.info "Finished tests, closing lock"
    $lock.close
    File.delete($lock_path)
    $logger.info "Done #{Time.now}"
    out = ENV['CC_BUILD_ARTIFACTS']
    $logger.info "ENV['CC_BUILD_ARTIFACTS'] = #{out}"
    if out
      FileUtils.mkdir_p(out) unless File.directory?(out)
      FileUtils.cp_r "coverage", out
    end
  end
end

before "multistage:prepare", "multistage:prepare_nested_locations"

namespace :multistage do
  desc "helper task to make prepare work with stages with subfolders like \"folder/stage\""
  task :prepare_nested_locations do
    location = fetch(:stage_dir, "config/deploy")
    stages.each do |name|
      if (dirname = File.dirname(name.to_s)) != '.'
        path = File.join(location, dirname)
        FileUtils.mkdir_p path
      end
    end
  end
end

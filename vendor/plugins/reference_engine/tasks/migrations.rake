namespace :re do
  namespace :migrations do
    desc "Copies all migrations from the reference engine to the main app"
    task :copy do
      for f in Dir.glob(File.join(RAILS_ROOT, 'vendor', 'plugins', 'reference_engine', 'db', 'migrate', '*'))
        File.copy f, File.join(RAILS_ROOT, 'db', 'migrate')
      end
    end
  end
end

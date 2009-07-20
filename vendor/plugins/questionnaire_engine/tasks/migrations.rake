namespace :qe do
  namespace :migrations do
    desc "Copies all migrations from the questionnaire engine to the main app"
    task :copy do
      for f in Dir.glob(File.join(RAILS_ROOT, 'vendor', 'plugins', 'questionnaire_engine', 'db', 'migrate', '*'))
        File.copy f, File.join(RAILS_ROOT, 'db', 'migrate')
      end
    end
  end
end

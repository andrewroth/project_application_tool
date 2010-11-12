class DatabaseGitProxyGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.file "database.proxy.yml", "config/database.proxy.yml"
      m.directory "config/database"
      m.file "databases.yml", "config/databases.yml"
    end
  end
end

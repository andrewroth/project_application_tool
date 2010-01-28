module Moonshine::Manifest::Rails::God

  # Installs <tt>god monitoring framework</tt> from gem and installs a config
  # to <tt>/etc/god/god.rb</tt>.  Adds a config file in 
  # <tt>/etc/god/apps/<application>.yml</tt> if :delayed_job is set to true in
  # moonshine.yml
  def god
    file '/etc/god', :ensure => :directory
    file '/etc/god/apps', :ensure => :directory
    file '/etc/god/god.rb',
      :ensure => :present,
      :content => template(File.join(File.dirname(__FILE__), 'templates', 'god.rb.erb'))
    if configuration[:delayed_job]
      file "/etc/god/apps/#{configuration[:application]}.yml",
        :ensure => :present,
        :content => template(File.join(File.dirname(__FILE__), 'templates', 'god_app.yml.erb'))
    end
    god_start
  end

  def god_start
    gem 'god', :before => exec("god_start", :command => "sudo god -c /etc/god/god.rb start")
  end

  def god_stop
    exec "god_stop", :command => "sudo god quit",
      :onlyif => "test `ps aux | grep '/usr/bin/ruby /usr/bin/god` -eq 0"
  end

  def god_restart
    god_stop
    god_start
  end
end

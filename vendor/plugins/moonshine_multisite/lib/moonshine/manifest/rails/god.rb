module Moonshine::Manifest::Rails::God

  # Installs <tt>god monitoring framework</tt> from gem and installs a config
  # to <tt>/etc/god/god.rb</tt>.  Starts the monitoring service.
  def god_delayed_job
    file '/etc/god', :ensure => :directory
    file '/etc/god/apps', :ensure => :directory
    file '/etc/god/god.rb',
      :ensure => :present,
      :content => template(File.join(File.dirname(__FILE__), 'templates', 'god.rb.erb'))
    file "/etc/god/apps/#{configuration[:application]}.yml",
      :ensure => :present,
      :content => template(File.join(File.dirname(__FILE__), 'templates', 'god_app.yml.erb'))
  end

  # Install the <tt>god</tt> rubygem and dependencies
  def god_gem
    gem('god')
  end

end

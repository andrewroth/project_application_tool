module Moonshine::Manifest::Rails::Monit

  # Installs <tt>monit monitoring framework</tt>
  # Adds a config file in 
  # <tt>/etc/monit.d/ if delayed_job is set to true
  def monit
    package "monit", :ensure => :installed

    file '/etc/monit.d', :ensure => :directory
    if configuration[:delayed_job]
      file "/etc/monit.d/dj_#{configuration[:server_name]}.monitrc",
        :ensure => :present,
        :content => template(File.join(File.dirname(__FILE__), 'templates', 'dj_monit.monitrc.erb')),
        :before => exec("monit_restart")
    end
    file "/etc/monit/monitrc",
      :ensure => :present,
      :content => template(File.join(File.dirname(__FILE__), 'templates', 'monitrc.erb')),
      :before => exec("monit_restart")
    file "/etc/default/monit"
      :ensure => :present,
      :content => template(File.join(File.dirname(__FILE__), 'templates', 'monit.erb')),
      :before => exec("monit_restart")
    monit_restart
  end

  def monit_restart
    exec "monit_restart", 
      :command => "sudo /etc/init.d/monit restart",
      :require => package("monit")
  end
end

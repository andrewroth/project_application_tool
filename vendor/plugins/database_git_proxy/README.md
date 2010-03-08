Rails Database Config Git Proxy
===============================

Load different database.yml files based on the current git branch.

Useful when using capistrano-ext multistages in combination db_mappings (http://github.com/twinge/db_mappings), such that you're developing to support multiple schemas.  Instead of changing database.yml each time you switch schemas, this plugin will enable you to map git branches to database config files.

Example
=======

**Install**

<pre>ruby script/plugin install git://github.com/andrewroth/database_git_proxy.git</pre>

**Generate**

<pre>ruby script/generate database_git_proxy</pre>

<pre>create  config/database.proxy.yml
create  config/database
create  config/databases.yml </pre>

**Activate**

<pre>rake db:proxy:activate</pre>

Backs up database.yml (if exists) then copies database.proxy.yml to database.yml

**Commit**

If you want everyone using your project to use the proxy, then add database.yml to git.

Another Example
===============

You can make use of erb to add config/database/* to git if you use erb to allow people to customize parts of the config files.  Then a new developer only customizes database_header.yml with a username and password.

config/database/database.dev.yml -- in git

    <%= 
    dbh = "#{RAILS_ROOT}/config/database/database_header.yml"; dbhd = dbh+".default";
    file = File.exists?(dbh) ? dbh : dbhd
    File.read(file).chomp
    %>

    development:
      database: app_dev
      <<: *defaults

    test:
      database: app_test
      <<: *defaults

config/database/database.master.yml -- in git

    <%= 
    dbh = "#{RAILS_ROOT}/config/database/database_header.yml"; dbhd = dbh+".default";
    file = File.exists?(dbh) ? dbh : dbhd
    File.read(file).chomp
    %>

    development:
      database: app_master
      <<: *defaults

    test:
      database: app_test
      <<: *defaults

config/database/database_header.yml.default -- in git

    # if database_header.yml is not found, these settings are used
    defaults: &defaults
      adapter: mysql
      username: root
      password:
      host: localhost

config/database/database.yml -- optional, kept out of git

    defaults: &defaults
      adapter: mysql
      username: mypassword
      password: bob
      host: localhost

Approach
========

databases.yml contains a mapping of git branches to config filenames.  You can also use regular expressions in databases.yml

database.yml contains erb code to determine the appropriate config filename using databases.yml 

Copyright (c) 2010 Andrew Roth, released under the MIT license

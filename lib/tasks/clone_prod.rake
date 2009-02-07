#require 'environment'

def all_confidential_parent_elements
  conf = Flag.find_by_name "confidential", :include => { :pages => :elements }

  conf.elements.reject{ |e| !e.confidential? } + 
  es = conf.pages.reject{ |p| !p.confidential? }.collect{ |p| p.elements }.flatten
  es
end

def all_confidential_elements(e = nil)
  if e
    if @visited[e.id]
      #puts "dup #{e.id}"
      return []
    else
      @visited[e.id] = true
    end
  end

  if e
    r = [ e ]
    for c in e.elements_cached
      r += all_confidential_elements c
    end
    r
  else
    @visited = []
    all_confidential_parent_elements.collect { |e|
      all_confidential_elements e
    }.flatten
  end
end

def clone_one_db(prod, dev)
  puts "cloning #{prod} to #{dev}"
  cmd = "mysqldump -h dbserver.crusade.org -u ciministry --password=########### --skip-lock-tables #{prod} | sed \"2 s/.*/SET SESSION sql_mode='NO_AUTO_VALUE_ON_ZERO';/\" | mysql -h dbserver.crusade.org -u ciministry --password=########### #{dev}"
  puts cmd
  system cmd
end

namespace "db:clone" do
  desc "clones the power to change ciministry and summerprojectool dbs to dev_campusforchrist and spt_dev respectively, and removes all answer to confidential qs from spt_dev"
  task :p2c => :environment do

    prod_spt = 'summerprojecttool'
    dev_spt = 'spt_dev'

    prod_cim = 'ciministry'
    dev_cim = 'dev_campusforchrist'

    sql = ActiveRecord::Base.connection
    sql.execute "drop database #{dev_spt}"
    sql.execute "create database #{dev_spt}"

    clone_one_db prod_spt, dev_spt
    clone_one_db prod_cim, dev_cim

    sql.execute "use #{dev_spt}"
    sql.execute "delete from #{dev_spt}.#{Answer.table_name} where (question_id in (#{all_confidential_elements.collect(&:id).join(',')}));"
    puts "deleted confidential answers from #{dev_spt}"
  end
end

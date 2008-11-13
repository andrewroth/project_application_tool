require 'find'
require 'etc'

desc 'Changes all files owned by the current user to www-data'
task :fix_permissions do
  uid = Etc.getpwnam(%x[whoami].chomp).uid
  www_uid = Etc.getpwnam('www-data').uid
  www_gid = Etc.getgrnam('www-data').gid

  Find.find(Dir.pwd) do |p|
    if File.lstat(p).uid == uid
      File.lchown www_uid, www_gid, p
    end
  end
end

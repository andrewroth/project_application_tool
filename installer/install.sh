echo "
This is the Project Application Tool (PAT) install script.
 located at http://static.ministryapp.com/canada/pat_auto/install.sh

 - You should be root.
 - You should also know the username and password of a regular user.
           Said user will be used with the capistrano tool to deploy the PAT.
 - This PAT installer requires a debian-based system.  Debian or ubuntu will do.
 - It will install the PAT using apache2 and mod_rails.

PAT web sites will go in /var/www/{name_of_domain}

You will be prompted along the way for various options.
"

echo -n "Continue? (y/n) "
read answer

if [ $answer == "y" ]
then

  # install required packages
  echo
  echo "First making sure required packages (ruby, subversion, mysql client) are installed.."
  echo
  apt-get install ruby irb ruby1.8-dev subversion libmysqlclient15-dev

  # check out everything locally
  echo
  echo "Checking out installer code and resource"
  svn co https://svn.ministryapp.com/pat/trunk/installer pat_installer

  # now switch to the ruby installer
  ruby pat_installer/install.rb
  #ruby installer/install.rb
fi


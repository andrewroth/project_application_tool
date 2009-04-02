require 'connexion_bar'
require 'ftools'

# copy our connexion.css to public if it's not there
src = File.join(File.dirname(__FILE__), 'assets', 'connexion_default.css')
dest = File.join(RAILS_ROOT, 'public', 'stylesheets', 'connexion_default.css')

unless File.exist? dest
  File.copy src, dest
end

ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

# support subfolders in fixtures
class Fixtures < YAML::Omap
  unless self.respond_to?('cached_fixtures_with_subdirs')
    def self.cached_fixtures_with_subdirs(connection, keys_to_fetch = nil)
      if keys_to_fetch
        keys_to_fetch = keys_to_fetch.collect{ |k|
          k.to_s.split('/').last
        }
      end
      cached_fixtures_without_subdirs connection, keys_to_fetch
    end

    class << self
      alias_method_chain :cached_fixtures, :subdirs
    end
  end
end

module TestHelper
  # Add more helper methods to be used by all tests here...
  def output_html_response(path = "public/response.html")
    File.open(path, "w") { |f|
        f.write(@response.body)
    }
  end

  def setup_spt
    @eg = EventGroup.find 1
    @request.session[:event_group_id] = @eg.id
    @request.session[:user_id] = $viewers['superadmin']
  end
end

class Test::Unit::TestCase
  include TestHelper
  
  # always load these fixtures
  fixtures "ciministry/accountadmin_viewer"
  fixtures "ciministry/accountadmin_accessgroup"
  fixtures "ciministry/accountadmin_vieweraccessgroup"
  fixtures "authservice/ministries"
  fixtures :event_groups

  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
  self.use_instantiated_fixtures  = false
  
end

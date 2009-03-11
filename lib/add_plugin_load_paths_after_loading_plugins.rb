module Engines
  class Plugin
    class Loader < Rails::Plugin::Loader
      def load_plugins
        super
        add_plugin_load_paths
      end
    end
  end
end

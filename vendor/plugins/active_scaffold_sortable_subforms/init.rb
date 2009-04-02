require "helpers/form_column_helpers.rb"

# install public files
['/public/images', '/public/javascripts'].each{|dir|
  source = File.join(directory,dir)
  dest = File.join(RAILS_ROOT, dir)
  FileUtils.mkdir_p(dest)
  FileUtils.cp_r(Dir.glob(source+'/*.*'), dest)
}

# unfortunately, I don't know how to override a view file from a plugin
# so I will copy it to active_scaffold_overrides
aso = File.join(RAILS_ROOT, 'app', 'views', 'active_scaffold_overrides')
aso_uf = File.join(aso, '_update_form.rhtml')
plugin_uf = File.join(File.dirname(__FILE__), 'views', '_update_form.rhtml')

unless File.directory?(aso) && File.exists?(aso_uf)
  FileUtils.mkdir_p(aso)
  FileUtils.cp(plugin_uf, aso_uf)
else
  # make sure they're actually different
  orig = File.read(aso_uf)
  new = File.read(plugin_uf)

  if orig != new
    puts %|WARNING: seems there's already an _update_form.rhtml override, you should merge 
the one in the active_scaffold_sortable_subform plugin to it
All that's added is the :before line (ln 13):

    form_remote_tag :url => url_options,
                    :after => "$('\#{loading_indicator_id(:action => :update, :id => params[:id])}').style.visibility = 'visible'; Form.disable('\#{element_form_id(:action => :update)}');",
                    :complete => "$('\#{loading_indicator_id(:action => :update, :id => params[:id])}').style.visibility = 'hidden'; Form.enable('\#{element_form_id(:action => :update)}');",
+                   :before => "as_dd_clear_empty_new_records($('\#{element_form_id(:action => :update)}'))",
                    :failure => "ActiveScaffold.report_500_response('\#{active_scaffold_id}')",
                    :html => {
                      :href => url_for(url_options),
                      :id => element_form_id(:action => :update),
                      :class => 'update',
                      :method => :put
                    }

|
  end
end

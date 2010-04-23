require 'db_mappings'
require 'require_model'

config.after_initialize do
  # Load any custom model files after the original ones, so that the original app 
  # can be extended without modifying the original app/models (instead,
  # require the base app/models files in the lib_path model files)
  @@map_hash ||= ''
  if @@map_hash && @@map_hash['lib_path']
    found_lib_path = ActiveSupport::Dependencies.load_paths.find{ |item| item[@@map_hash['lib_path']] }
    if found_lib_path
      ActiveSupport::Dependencies.load_paths.delete found_lib_path
      ActiveSupport::Dependencies.load_paths.unshift found_lib_path
    else
      ActiveSupport::Dependencies.load_paths.unshift @@map_hash['lib_path']
    end
  end
end

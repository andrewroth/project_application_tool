def change_key(old_key, new_key, old_label)
  label = MultilingualLabel.find_by_label_key(@old_key)

  # make sure it's the right one...
  if (!label.nil? && label.label_label == old_label)
    # there is usually more than one label
    sql = "update #{CIMinistryBase.ciministry_db}.site_multilingual_label " +
      "set label_key = '#{@new_key}' " + 
      "where label_key = '#{@old_key}'"
    puts sql
    execute sql
    
    pc = Accessgroup.find_by_accessgroup_key(@old_key)
    pc.accessgroup_key = @new_key
    pc.save
  else
    puts "note: skipping migration because '#{old_key}'s label is not '#{old_label}'."
  end
end

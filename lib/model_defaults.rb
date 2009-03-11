# there are two places the default text area comes up, one is editing, one is
# instance.  for editing, it shows up because the form for a text area says 
# essentially "the default is ..., you can override it"
# 
# note that a constant doesn't work because the overriding classes might use
# a dynamic way of getting a the limit (like the spt, you can set a default
# limit for every event group)
#
module ModelDefaults
  def default_text_area_max_length
    if @appln
      @appln.form.event_group.default_text_area_length
    elsif @eg
      @eg.default_text_area_length
    end
  end
end


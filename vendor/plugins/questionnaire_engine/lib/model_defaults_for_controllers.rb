# there are two places the default text area comes up, one is editing, one is
# instance.  for editing, it shows up because the form for a text area says 
# essentially "the default is ..., you can override it"
# 
# note that a constant doesn't work because the overriding classes might use
# a dynamic way of getting a the limit (like the spt, you can set a default
# limit for every event group)
#
# I can't seem to make engines mix in lib classes, so I need to rename
# this (from model-defaults.rb to what it is now) so that it doesn't get 
# overridden by an app lib file
module ModelDefaultsForControllers
  include ModelDefaults

  DEFAULT = 4000

  # uses our own default 
  def default_text_area_max_length_with_default
    overridden_default = if self.respond_to?(:default_text_area_max_length) then
      default_text_area_max_length else nil end

    (overridden_default && overridden_default != 0) ? overridden_default : DEFAULT
  end

  def set_default_text_area_max_length
    @default_text_area_max_length = default_text_area_max_length_with_default
  end
end


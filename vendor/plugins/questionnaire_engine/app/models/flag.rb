class NoSuchFlag < RuntimeError
end

class Flag < ActiveRecord::Base
  set_table_name "#{QE.prefix}flags"
  has_many :element_flags
  has_many :page_flags
  has_many :elements, :through => :element_flags
  has_many :pages, :through => :page_flags
  
  def Flag.get_flag_obj(flag_str)
    flag_object = Flag.find_by_name(flag_str)
    raise NoSuchFlag, "No such flag " + flag_str.to_s if flag_object.nil? 
    return flag_object
  end
end

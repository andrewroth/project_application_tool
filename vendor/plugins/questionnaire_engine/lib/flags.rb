module Flags

  def method_missing(*params)
    m = params[0].to_s
    
    # try to assign or read flags
    m.scan(/(is_)?(\w+)[=|\?]/) do |flag_str|
      flag_str = flag_str[1] # for some reason the string come as a single sized array
      begin
        if m.last_char == '?'
          return get_value_of(flag_str)
        elsif m.last_char == '='
          return set_flag_value(flag_str, params[1])
        end
      rescue NoSuchFlag
        super
      end
    end

    super
  end
  
  def self.setup(*params)
    params = params[0]
    base = params[:self]
    
    base.class_eval do
      c = "define_method('flag_values_model') do #{params[:flag_values_model]} end"
#      puts c
      eval c
      
      has_many :flag_values, :class_name => params[:flag_values_model].to_s
    end
  end
  
  def clone
    clone = super
    flags.each do |f|
      clone.send("is_#{f}=", self.send("is_#{f}?"))
    end
    clone
  end

  def flags
    all_flags = flag_values_model.cache.values
    
    # f[0] is name, f[1] is value
    flags = all_flags[id].nil? ? [] : all_flags[id].collect{ |f| f[1] ? f[0] : nil }.compact
  end
  
  def get_flag_value_tuple(flag_str)
    return flag_values.find_by_flag_id(Flag.get_flag_obj(flag_str).id)
  end
  
  def get_value_of(flag)
    this_elements_flags = flag_values_model.cache.values[id]
    return this_elements_flags.nil? ? nil : this_elements_flags[flag] == true
  end
  
  def set_flag_value(flag_str, value)
    tuple = get_flag_value_tuple(flag_str)
    if tuple.nil?
      tuple = flag_values_model.new(:flag_id => Flag.get_flag_obj(flag_str).id)
      tuple.subject = self
    end
    tuple.value = value
    tuple.save!
    flag_values_model.cache.load! # force reload
    return value
  end  
end

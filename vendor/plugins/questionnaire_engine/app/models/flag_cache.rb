class FlagCache
  public
  
  def initialize(base)
    @base = base
    load!
  end
  
  def values
    @flags
  end
  
  def cache
    begin
      load_cache if @flags.nil?
      @flags
    rescue NameError
      load_cache
      @flags
    end
  end
  
  def load!
    @flags = {}
    subject_column = @base.reflections[:subject].options[:foreign_key]
    @base.find(:all, :include => :flag).each do |fv| # flag value
      subject_id = fv.send(subject_column)
      next if subject_id.nil? or fv.flag.nil?
      @flags[subject_id] = {} if @flags[subject_id] == nil
      @flags[subject_id][fv.flag.name] = fv.value?
    end
    @flags
  end
end

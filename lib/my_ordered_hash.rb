class MyOrderedHash < Hash
  alias_method :store, :[]=
  #alias_method :each_pair, :each  # This doesn't seem to register sometimes, so the alias is done manually
  
  def clone
    MyOrderedHash.new self.to_a.flatten
  end
  
  def to_a
    self.collect { |k,v| [ k, v ] }
  end
  
  def each_pair
    each do |k,v|
      yield k,v
    end
  end
  
  def position(k)
    @keys.index k
  end

  def initialize(*params)
    @keys = []
    if !params.nil? && params[0].class == Array
      params[0].each_with_index do |k,i|
        if i % 2 == 0
          v = params[0][i+1]
          self[k] = v
        end
      end
    end
  end
  
  def merge!(other)
    other.each_pair do |k,v|
      self[k] = v
    end
  end
  
  def []=(key, val)
    @keys << key unless @keys.include?(key)
    super
  end
  
  def delete(key)
    @keys.delete(key)
    super
  end
  
  def each
    @keys.each { |k| yield [ k, self[k] ] }
  end
  
  def keys() @keys end
  
  def values() keys.collect{ |k| self[k] } end
  
  def each_key
    @keys.each { |k| yield k }
  end
  
  def each_value
    @keys.each { |k| yield self[k] }
  end
  
end

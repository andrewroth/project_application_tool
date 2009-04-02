class DateTime
  def self.new_from_hash(params)
    year = extract_int_from_hash params, 'year'
    month = extract_int_from_hash params, 'month'
    day = extract_int_from_hash params, 'day'
    self.new(year, month, day)
  end

  protected

  def self.extract_int_from_hash(h, k)
    v = h[k.to_sym] || h[k.to_s]
    v.to_i
  end
end

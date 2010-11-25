module DateParamsParser
  def self.parse(hash, key)
    if hash["#{key.to_s}(1i)"]
      i1 = hash.delete "#{key.to_s}(1i)"
      i2 = hash.delete "#{key.to_s}(2i)"
      i3 = hash.delete "#{key.to_s}(3i)"
    elsif hash[key.to_s]["year"]
      i1 = hash[key.to_s].delete "year"
      i2 = hash[key.to_s].delete "month"
      i3 = hash[key.to_s].delete "day"
    end
    if i1.present? && i2.present? && i3.present?
      hash[key.to_sym] = Date.new(i1.to_i, i2.to_i, i3.to_i)
    end
  end
end

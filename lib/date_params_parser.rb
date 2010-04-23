module DateParamsParser
  def self.parse(hash, key)
    i1 = hash.delete "#{key.to_s}(1i)"
    i2 = hash.delete "#{key.to_s}(2i)"
    i3 = hash.delete "#{key.to_s}(3i)"
    if i1.present? && i2.present? && i3.present?
      hash[key.to_sym] = Date.new(i1.to_i, i2.to_i, i3.to_i)
    end
  end
end

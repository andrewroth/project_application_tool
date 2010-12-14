class String
  def clean!
    self.gsub!(/./) { |s| s[0] >= 128 ? '' : s }
  end
  def clean
    self.gsub(/./) { |s| s[0] >= 128 ? '' : s }
  end
end


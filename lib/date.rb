class Date
  def <=>(other)
    if other.nil?
      return -1
    else
      self - other
    end
  end
end

class Time
  def <=>(other)
    if other.nil?
      -1
    else
      self - other
    end
  end
end

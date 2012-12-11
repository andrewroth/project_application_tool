class DateTime
  def <=>(other)
    if other.nil?
      return -1
    else
      super
    end
  end
end

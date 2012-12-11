class NilClass
  def <=>(other)
    if other.is_a?(Time) || other.is_a?(DateTime) || other.is_a?(Date) || other.is_a?(PrepItemCategory)
      return 1
    else
      self - other
    end
  end
end

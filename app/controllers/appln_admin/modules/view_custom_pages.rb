module ViewCustomPages

  def references
    get_references
  end
  
  def get_references
    @references = @appln.reference_instances
  end
end

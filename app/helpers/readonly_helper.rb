module ReadonlyHelper
  def q(q,a)
    render :partial => 'readonly/textarea_equivalent',
      :locals => { :question => q, :answer => a }
  end
end

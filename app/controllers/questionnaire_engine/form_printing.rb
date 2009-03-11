module FormPrinting
  def self.included(base)
    base.class_eval do
      alias_method :index_without_form_printing, :index
      alias_method :index, :index_with_form_printing
    end
  end
  
  def index_with_form_printing
    if params[:view] == 'print'
      render :inline => '', :layout => 'form_print'
    else
      index_without_form_printing
    end
  end
end

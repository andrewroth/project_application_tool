# template should display a loading message when @form is 'loading' and
#  the actual form template when @form is 'view'
#  
module FormLoadingIndicator

  def get_page
    @form = "view"
    super
  end
  
  def self.included(base)
    base.class_eval do
      alias_method :index_without_show_form, :index
      alias_method :index, :index_with_show_form 
      define_method(:show) do index end
    end
  end
  
  def index_with_show_form
    @pass_params[:view] = params[:view] || 'view'
    
    if (params[:load_all_pages])
      params[:layout] = "form_#{params[:view]}"
      params[:no_save] = true

      index_without_show_form
      
    else
      @form = "loading"
      params[:layout] = true
      
      if params[:view] == 'print'
        @layout = 'form_print'
      else
        @layout ||= true
        @content = ''
      end
      
      render :inline => @content, :layout => @layout
    end
  end
  
end

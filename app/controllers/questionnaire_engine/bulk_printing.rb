module BulkPrinting
  def bulk_forms
    project_title = @project.title.to_s
    page_title = @page_title.to_s

    render :inline => "#{project_title} #{page_title}, Generated at #{Time.now}", :layout => "form_bulk_print" unless RAILS_ENV == 'test'
  end

  def bulk_acceptance_forms(includes = {})
    if params[:viewer_id] && params[:viewer_id] != 'all'
      @items = Acceptance.find_all_by_viewer_id_and_project_id params[:viewer_id], @project.id, :include => includes
      @items += Applying.find_all_by_viewer_id_and_project_id params[:viewer_id], @project.id, :include => includes
    else
      @items = Acceptance.find_all_by_project_id @project.id #, :include => includes # seems to give an error
      @items += Applying.find_all_by_project_id @project.id #, :include => includes # seems to give an error
    end
    
    @instances = []
    for acc in @items
      next if acc.appln.nil?
      yield acc
    end

    bulk_forms
  end
end


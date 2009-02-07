class FeedbacksController < ApplicationController
  skip_before_filter :restrict_students
  before_filter :set_title 

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }
  
  before_filter :ensure_eventgroup_coordinator, :only => [ :list ]
  
  def list
    @submenu_title = "List"
    @feedbacks = @eg.feedbacks.find(:all)
    render :layout => !request.xml_http_request?
  end

  def show
    @feedback = @eg.feedbacks.find(params[:id])
  end

  def new
    @submenu_title = "New"
    @feedback = Feedback.new
    @feedback.event_group_id = @eg.id
    @type = "Choose a Type"
    @viewer_id = @user.viewer.id
    render :layout => !request.xml_http_request?
  end

  def create
    @feedback = Feedback.new params[:feedback].merge(:event_group_id => session[:event_group_id])
    @feedback.viewer_id = @user.viewer.id
    
    if @feedback.save
      email = FeedbackMailer.create_forward(@feedback)
      FeedbackMailer.deliver(email)
      flash[:notice] = 'Thank you for your feedback.'
      redirect_to :controller => :main, :action => :index
    else
      render :action => 'new'
    end
  end

  def destroy
    @feedback = @eg.feedbacks.find params[:id]
    @feedback.destroy
    redirect_to :action => 'list'
  end
  
  protected
  def set_title
    @page_title = "Feedback"
  end
  
  def ensure_projects_coordinator
    @user.is_eventgroup_coordinator?
  end
end

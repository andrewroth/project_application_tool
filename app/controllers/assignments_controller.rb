class AssignmentsController < ApplicationController
  before_filter :set_person

  skip_before_filter :restrict_students, :only => [ :new, :update ]

  def new
    @new = Assignment.new
    @new.id = params[:id] || 1
  end

  def update
    CampusInformation.save_from_params @person, params

    flash[:notice] = 'Saved campus info.'

    redirect_to :controller => :profiles, :action => :campus_info
    #render :inline => @debug
  end

  def index
    @assignments = @person.assignments
  end

  def show
    @assignment = Assignment.find params[:id]
    @new_id = @assignment.id
  end

  def delete
    @assignment = @person.assignments.find params[:id]
    @show_dom_id = "assignment_#{@assignment.id}_show"
    @edit_dom_id = "assignment_#{@assignment.id}_edit"
    @assignment.destroy
  end

  private

  def set_person
    @person = @user.viewer.person
    (flash[:error] = 'Need to be logged in') & render(:inline => '') unless @person
  end
end

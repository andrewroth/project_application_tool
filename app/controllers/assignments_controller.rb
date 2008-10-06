class AssignmentsController < ApplicationController
  before_filter :set_person

  def new
    @new = Assignment.new
    @new.id = params[:id] || 1
  end

  def update
    if params[:assignment][:new]
      for new_map in params[:assignment][:new].values
        a = Assignment.new new_map
        a.person_id = @person.id
        a.save!
      end
    end

    if params[:assignment][:update]
      for id, upd_map in params[:assignment][:update]
        puts "[#{id} #{upd_map}]"
        begin
          a = @person.assignments.find id
        rescue Exception
        end
        a.update_attributes upd_map
        a.person_id = @person.id
        a.save!
      end
    end

    flash[:notice] = 'Saved assignments.'

    redirect_to :action => :index
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

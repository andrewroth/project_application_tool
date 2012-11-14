require_dependency 'permissions.rb'

class OptinCostItemsController < ApplicationController
  include Permissions

  skip_before_filter :restrict_students
  before_filter :get_cost_item, :except => [ :index, :sums, :list, :create ]
  before_filter :get_profile
  before_filter :ensure_profile_ownership_or_any_project_staff
  before_filter :get_cost_items, :only => [ :index, :sums, :set_opt, :list, :create ]
  
  in_place_edit_for :cost_item, :description
  in_place_edit_for :cost_item, :amount

  def index
  	@submenu_title = 'costing'
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    sums    
    @opted = Hash[*@cost_items.collect{ |ci| [ci.id, !ci.optins.find_by_profile_id(@profile).nil?] }.flatten]
  end

  def sums
    @total, *@sums = @profile.calculate_sums(@cost_items)
  end
  
  # returns sums template
  def set_opt
    value = params[:value] == 'true'
    opt = OptinCostItem.find_by_cost_item_id params[:id]
    opt = @cost_item.optins.find_by_profile_id @profile
    if opt && !value
      opt.destroy
    elsif !opt && value
      @cost_item.optins.create :profile_id => @profile.id
    end
    sums
    render :action => 'sums'
  end

  def destroy
    @cost_item.destroy
  end
  
  def create
    params[:cost_item] ||= { }
    if !params[:profile_id].nil?
      params[:cost_item][:profile_id]  ||= params[:profile_id]
    else
      render :inline => "No access to create a new profile cost-item."
      return
    end
    params[:cost_item][:event_group_id] ||= @eg.id
    params[:cost_item][:description]    ||= 'new item'
    params[:cost_item][:amount]         ||= 0.00
    params[:cost_item][:optional]       ||= true
    
    @cost_item = ProfileCostItem.new(params[:cost_item])
    if @cost_item.save
      flash[:notice] = 'CostItem was successfully created.'
      get_cost_items
      list
    else
      render :action => 'new'
    end
    @profile.reload
  end
  
  def update
    @cost_item = CostItem.find(params[:id])
    if @cost_item.update_attributes(params[:cost_item])
      flash[:notice] = 'CostItem was successfully updated.'
      redirect_to :action => 'show', :id => @cost_item
    else
      render :action => 'edit'
    end
  end

  protected

  def get_profile
    if @cost_item.class.name == "ProfileCostItem"
      @profile = @cost_item.profile
    else
      @profile = Profile.find params[:profile_id]
    end
  end

  def get_cost_item
    @cost_item = CostItem.find( params[:cost_item_id] || params[:id] )
  end

  def get_cost_items
    @cost_items = @profile.all_cost_items(@eg)
    
    @cost_items.sort!
  end
end

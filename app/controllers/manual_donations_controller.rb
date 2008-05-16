class ManualDonationsController < ApplicationController

  before_filter :set_title

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @submenu_title = "List"
    @manual_donations = ManualDonation.find(:all)
  end

  def show
    @manual_donation = ManualDonation.find(params[:id])
  end

  def new
    @submenu_title = "New"
    @manual_donation = ManualDonation.new
    @manual_donation.motivation_code = params[:motv_code]
    @donation_types = DonationType.find(:all, :order => "description").map {|t| [t.description, t.id]}
  end

  def create
    @manual_donation = ManualDonation.new(params[:manual_donation])
    if @manual_donation.save
      flash[:notice] = 'Manual Donation has been saved.'
      redirect_to :controller => :main, :action => :index
    else
      render :action => 'new'
    end
  end

  def edit
    @manual_donation = ManualDonation.find(params[:id])
    @donation_types = DonationType.find(:all, :order => "description").map {|t| [t.description, t.id]}
  end

  def update
    @manual_donation = ManualDonation.find(params[:id])
    if @manual_donation.update_attributes(params[:manual_donation])
      flash[:notice] = 'ManualDonation was successfully updated.'
      redirect_to :action => 'show', :id => @manual_donation
    else
      render :action => 'edit'
    end
  end

  def destroy
    ManualDonation.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  protected
  
  def set_title() @page_title = "Tools" end
  
end

class ReasonForWithdrawalsController < ApplicationController
  # GET /reason_for_withdrawals
  # GET /reason_for_withdrawals.xml
  def index
    @reason_for_withdrawals = @eg.reason_for_withdrawals

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @reason_for_withdrawals.to_xml }
    end
  end

  # GET /reason_for_withdrawals/1
  # GET /reason_for_withdrawals/1.xml
  def show
    @reason_for_withdrawal = ReasonForWithdrawal.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @reason_for_withdrawal.to_xml }
    end
  end

  # GET /reason_for_withdrawals/new
  def new
    @reason_for_withdrawal = ReasonForWithdrawal.new
  end

  # GET /reason_for_withdrawals/1;edit
  def edit
    @reason_for_withdrawal = ReasonForWithdrawal.find(params[:id])
  end

  # POST /reason_for_withdrawals
  # POST /reason_for_withdrawals.xml
  def create
    @reason_for_withdrawal = ReasonForWithdrawal.new(params[:reason_for_withdrawal])
    @reason_for_withdrawal.event_group_id = @eg.id

    respond_to do |format|
      if @reason_for_withdrawal.save
        flash[:notice] = 'ReasonForWithdrawal was successfully created.'
        format.html { redirect_to reason_for_withdrawal_url(@reason_for_withdrawal) }
        format.xml  { head :created, :location => reason_for_withdrawal_url(@reason_for_withdrawal) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @reason_for_withdrawal.errors.to_xml }
      end
    end
  end

  # PUT /reason_for_withdrawals/1
  # PUT /reason_for_withdrawals/1.xml
  def update
    @reason_for_withdrawal = ReasonForWithdrawal.find(params[:id])

    respond_to do |format|
      if @reason_for_withdrawal.update_attributes(params[:reason_for_withdrawal])
        flash[:notice] = 'ReasonForWithdrawal was successfully updated.'
        format.html { redirect_to reason_for_withdrawal_url(@reason_for_withdrawal) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @reason_for_withdrawal.errors.to_xml }
      end
    end
  end

  # DELETE /reason_for_withdrawals/1
  # DELETE /reason_for_withdrawals/1.xml
  def destroy
    @reason_for_withdrawal = ReasonForWithdrawal.find(params[:id])
    @reason_for_withdrawal.destroy

    respond_to do |format|
      format.html { redirect_to reason_for_withdrawals_url }
      format.xml  { head :ok }
    end
  end
end

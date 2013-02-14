class SitsController < ApplicationController
  # Authenticate (devise) for adding, editing, updating or removing sits
  before_filter :authenticate_user!, :only => [:new, :edit, :update, :destroy]

  # GET /sits
  def index
    @sits = Sit.newest_first.paginate(:page => params[:page])
  end

  # GET /sits/1
  def show
    @sit = Sit.find(params[:id])
    @user = @sit.user
  end

  # GET /sits/new
  def new
    @sit = Sit.new
    @user = current_user
  end

  # GET /sits/1/edit
  def edit
    @sit = Sit.find(params[:id])
    @user = current_user
  end

  # POST /sits
  def create
    @user = current_user
    @sit = @user.sits.new(params[:sit])

    if @sit.save
      redirect_to @sit, notice: 'Sit was successfully created.'
    else
      render action: "new"
    end
  end

  # PUT /sits/1
  def update
    @sit = Sit.find(params[:id])

    if @sit.update_attributes(params[:sit])
      redirect_to @sit, notice: 'Sit was successfully updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /sits/1
  def destroy
    @sit = Sit.find(params[:id])
    @sit.destroy

    redirect_to sits_url
  end
end

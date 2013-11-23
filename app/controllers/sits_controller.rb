class SitsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]

  # GET /sits/1
  def show
    @sit = Sit.find(params[:id])
    redirect_to me_path if @sit.private == true && @sit.user_id != current_user.id
    
    @user = @sit.user
    @title = "#{@sit.full_title} by #{@user.display_name}"
    @page_class = 'view-sit'
  end

  # GET /sits/new
  def new
    @sit ||= Sit.new
    @user = current_user

    @title = 'New sit'
    @page_class = 'new-sit'
  end

  # GET /sits/1/edit
  def edit
    @sit = Sit.find(params[:id])
    @user = current_user

    @title = 'Edit sit'
    @page_class = 'edit-sit'
  end

  # POST /sits
  def create
    @user = current_user
    @sit = @user.sits.new(params[:sit])

    if @sit.save
      redirect_to @sit, notice: 'Sit was successfully created.'
    else
      @page_class = 'new-sit'
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

    redirect_to me_path
  end
end

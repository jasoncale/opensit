class SitsController < ApplicationController
  before_filter :authenticate_user!, :only => [:new, :edit, :update, :destroy]

  # Index
  def index
    @sits = Sit.paginate(:page => params[:page]).order("created_at DESC").all
  end

  # View sit
  def show
    @sit = Sit.find(params[:id])
    @user = @sit.user
    @type = sit_type(@sit)
  end

  # Returns sit type; sit, diary or article.
  def sit_type(sit)
    if sit.s_type == 0
      'sit'
    elsif sit.s_type == 1
      'diary'
    else
      'article'
    end
  end

  # GET /sits/new
  def new
    @sit = Sit.new
  end

  # GET /sits/1/edit
  def edit
    @sit = Sit.find(params[:id])
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

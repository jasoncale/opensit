class SitsController < ApplicationController
  # GET /sits
  # GET /sits.json
  def index
    @sits = Sit.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sits }
    end
  end

  # GET /sits/1
  # GET /sits/1.json
  def show
    @sit = Sit.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @sit }
    end
  end

  # GET /sits/new
  # GET /sits/new.json
  def new
    @sit = Sit.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @sit }
    end
  end

  # GET /sits/1/edit
  def edit
    @sit = Sit.find(params[:id])
  end

  # POST /sits
  # POST /sits.json
  def create
    @sit = Sit.new(params[:sit])

    respond_to do |format|
      if @sit.save
        format.html { redirect_to @sit, notice: 'Sit was successfully created.' }
        format.json { render json: @sit, status: :created, location: @sit }
      else
        format.html { render action: "new" }
        format.json { render json: @sit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /sits/1
  # PUT /sits/1.json
  def update
    @sit = Sit.find(params[:id])

    respond_to do |format|
      if @sit.update_attributes(params[:sit])
        format.html { redirect_to @sit, notice: 'Sit was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @sit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sits/1
  # DELETE /sits/1.json
  def destroy
    @sit = Sit.find(params[:id])
    @sit.destroy

    respond_to do |format|
      format.html { redirect_to sits_url }
      format.json { head :no_content }
    end
  end
end

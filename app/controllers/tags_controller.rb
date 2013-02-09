class TagsController < ApplicationController

  # GET /tags
  def index
  end

  # GET /tags/:id
  def show
    @sits = Sit.tagged_with(params[:id])
  end

end

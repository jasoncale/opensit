class TagsController < ApplicationController

  # GET /tags
  def index
  end

  # GET /tags/:id
  def show
		if Tag.find_by_name(params[:id]) != nil
			@sits = Sit.tagged_with(params[:id])
		else
			redirect_to front_path
		end
  end

end

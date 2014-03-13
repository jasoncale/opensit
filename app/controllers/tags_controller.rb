class TagsController < ApplicationController

  # GET /tags/:id
  def show
		if Tag.find_by_name(params[:id]) != nil
			@sits = Sit.tagged_with(params[:id])
		else
			redirect_to root_path
		end

    @title = "Tag: #{params[:id]}"
    @page_class = 'view-tag'
  end

end

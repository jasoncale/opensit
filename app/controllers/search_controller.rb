class SearchController < ApplicationController
  def main
  	@users = User.fuzzy_search(params[:q]).paginate(:page => params[:page])
  	@sits = Sit.basic_search(params[:q]).communal.paginate(:page => params[:page])
    if Tag.find_by_name(params[:q]) != nil
      @tagged = Sit.tagged_with(params[:q]).communal.paginate(:page => params[:page])
  	end
    @page_class = "search-results"
    @title = "Search: #{params[:q]}"

  	type = params[:type]

	  if !type
  	 render 'sits'
    elsif type == 'users'
  		render 'users'
  	elsif type == 'tagged'
      render 'tagged'
    else
  		render 'sits'
  	end
  end

end

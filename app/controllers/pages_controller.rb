class PagesController < ApplicationController
  def front
    if signed_in?
      @title = "Home"
      @current_user = current_user
      @memberships  = @current_user.memberships.paginate(:per_page => 8, :page => params[:page])
	    render 'users/show'
    end
  end
end

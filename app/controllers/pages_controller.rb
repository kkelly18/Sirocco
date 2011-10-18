class PagesController < ApplicationController
  def front
    if signed_in?
      @current_user = current_user
	    redirect_to user_path(@current_user)
    end
  end
end

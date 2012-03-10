class PagesController < ApplicationController
  def front
    if signed_in?
      @current_user = current_user
      if signed_into_project?
        @current_project = current_project
        redirect_to project_path(@current_project)
      else
	      redirect_to user_path(@current_user)
      end
    end
  end
end

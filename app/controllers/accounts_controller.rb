class AccountsController < ApplicationController
  def show
    @current_user = current_user
    @account      = Account.find(params[:id])
    @new_project  = @account.projects.build
    @memberships  = @current_user.query_memberships(@account).paginate(:per_page => 6, :page => params[:page])
  end

end

class AccountsController < ApplicationController

  def show
    @current_user = current_user
    @account      = Account.find(params[:id])
    @new_project  = @account.projects.build
    @memberships  = @current_user.query_memberships(@account).paginate(:per_page => 6, :page => params[:page])
  end

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(params["account"])
    if @account.save
      flash[:success] = "Welcome to #{@account.name}"
      redirect_to :back
    else
      render 'new'
    end        
  end

end

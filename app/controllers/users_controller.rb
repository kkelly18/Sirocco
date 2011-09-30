class UsersController < ApplicationController
  def index
    @users = User.paginate(:per_page => 18, :page => params[:page])
  end

  def show
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    
    if @user.save      
      flash[:success] = "Welcome #{params[:user][:name]}!"
    else
      flash[:notice] = "Oops. Can't save that user."
    end
    redirect_to users_path
  end

  def edit
  end

end

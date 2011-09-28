class UsersController < ApplicationController
  def index
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
    redirect_to :back
  end

  def edit
  end

end

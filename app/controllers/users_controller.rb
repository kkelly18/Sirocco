class UsersController < ApplicationController
  before_filter :authenticate,    :except => [:show, :new, :create]  
  
  def index
    @users = User.paginate(:per_page => 6, :page => params[:page])
  end

  def show
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    
    if @user.save
      sign_in @user      
      redirect_to users_path, :flash => {:success => "Welcome #{params[:user][:name]}!"}
    else
      render 'new'
    end

  end

  def edit
  end

  def update
  end
  
  def destroy
  end

end

class UsersController < ApplicationController
  before_filter :authenticate,    :except => [:new, :create]  

  def show
    @title = "Home"
    @command = params[:command]
    case 
      when @command == nil || @command =~ /PROJECTS/i 
        @items_partial = 'projects/index'
        @items_text = 'SHOW ACCOUNTS'
        @items_command = 'ACCOUNTS'
        @command_form_partial = nil
      when @command =~ /ACCOUNTS/i
        @items_partial = 'accounts/index'
        @items_text = 'SHOW PROJECTS'
        @items_command = 'PROJECTS'
        @command_form_partial = 'accounts/new_account'
        @new_account = Account.new
      else
        @items_partial = 'projects/index'        
        @items_text = 'SHOW ACCOUNTS'
        @items_command = 'ACCOUNTS'
        @command_form_partial = nil
    end
    @current_user = current_user
    @memberships  = @current_user.memberships.paginate(:per_page => 8, :page => params[:page])
    @sponsorships = @current_user.sponsorships.paginate(:per_page => 8, :page => params[:page])
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    
    if @user.save
      sign_in @user      
      redirect_to  @user.personal_account, :flash => {:success => "Welcome #{params[:user][:name]}!"}
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

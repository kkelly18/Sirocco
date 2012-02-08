class UsersController < ApplicationController
  before_filter :authenticate,    :except => [:new, :create]  

  def show
    @title = "Home"
    @current_user = current_user
    @command = params[:command]
    case 
      when @command == nil || @command =~ /PROJECTS/i
        #@list_partial
        #@list_data
        @items_partial        = 'projects/index'
        @memberships          = @current_user.memberships.paginate(:per_page => 8, :page => params[:page])

        #@commands[{:text, :command}]
        @items_text           = 'MY ACCOUNTS'
        @items_command        = 'ACCOUNTS'

        #@partials[[:template, :meta{}]]
        @command_form_partial = nil
      when @command =~ /ACCOUNTS/i
        @items_partial        = 'accounts/index'
        @sponsorships         = @current_user.sponsorships.paginate(:per_page => 8, :page => params[:page])

        @items_text           = 'MY PROJECTS'
        @items_command        = 'PROJECTS'
        
        @command_form_partial = 'accounts/new_account'
        @new_account          = Account.new
      else
        #TODO log application error
    end
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
end

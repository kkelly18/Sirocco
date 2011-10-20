class AccountsController < ApplicationController
  before_filter :authenticate
  
  def show
    @current_user = current_user
    @account      = Account.find(params[:id])
    @new_project  = @account.projects.build
    @memberships  = @current_user.query_memberships(@account).paginate(:per_page => 6, :page => params[:page])

    @command = params[:command]
    case 
      when @command == nil || @command =~ /PROJECTS/i 
        @items_text = 'SHOW TEAM'
        @items_command = 'TEAM'
        @command_form_partial = 'projects/new_project'
        @items_partial = 'projects/index'
      when @command =~ /TEAM/i
        @team_members = @account.team_members.paginate(:per_page => 6, :page => params[:page])
        @items_text = 'SHOW PROJECTS'
        @items_command = 'PROJECTS'
        @command_form_partial = 'accounts/invite_user'
        @invited_user = Sponsorship.new
        @items_partial = 'accounts/team_members'
      else
        @items_text = 'SHOW TEAM'
        @items_command = 'TEAM'
        @command_form_partial = 'projects/new_project'
        @items_partial = 'projects/index'
    end    
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

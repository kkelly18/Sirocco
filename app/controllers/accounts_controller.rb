class AccountsController < ApplicationController
  before_filter :authenticate
  
  def show
    @title        = "Account"
    @current_user = current_user
    @account      = Account.find(params[:id])
    @new_project  = @account.projects.build
    @memberships  = @current_user.query_memberships(@account).paginate(:per_page => 6, :page => params[:page])

    @command = params[:command]
    case 
      when @command == nil || @command =~ /PROJECTS/i 
        @items_text = 'SHOW TEAM'
        @items_command = 'TEAM'
        if current_user_is_account_admin?
          @command_form_partial = 'projects/new_project'
        else
          @command_form_partial = nil
        end
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
        if current_user_is_account_admin?(@account)
          @command_form_partial = 'projects/new_project'
        else
          @command_form_partial = nil
        end
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
  
  private
    def current_user_is_account_admin?
      u = User.find(@current_user).sponsorships.where(:account_id => @account.id).first
      if u
        return u.access_admin?
      else
        return false
      end
    end

end

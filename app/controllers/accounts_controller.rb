class AccountsController < ApplicationController
  before_filter :authenticate
  
  def show
    @title        = "Account"
    @current_user = current_user
    @account      = Account.find(params[:id])

    @command = params[:command]
    case 
      when @command == nil || @command =~ /PROJECTS/i 
        @memberships  = @current_user.query_memberships(@account).paginate(:per_page => 6, :page => params[:page])
        @items_text = 'SHOW TEAM'
        @items_command = 'TEAM'
        if current_user_is_account_admin?
          @new_project          = @account.projects.build
          @command_form_partial = 'projects/new_project'
        else
          @command_form_partial = nil
        end
        @items_partial = 'projects/index'
      when @command =~ /TEAM/i
        @sponsorships = @account.sponsorships.paginate(:per_page => 6, :page => params[:page])
        @items_text = 'SHOW PROJECTS'
        @items_command = 'PROJECTS'
        if current_user_is_account_admin?
          @invited_user         = Sponsorship.new
          @command_form_partial = 'invite_user_to_account'
        else
          @command_form_partial = nil
        end
        @items_partial = 'sponsorships/account_team_members_index'
       else
        @memberships  = @current_user.query_memberships(@account).paginate(:per_page => 6, :page => params[:page])
        @items_text = 'SHOW TEAM'
        @items_command = 'TEAM'
        if current_user_is_account_admin?(@account)
          @new_project  = @account.projects.build
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

class ProjectsController < ApplicationController
  before_filter :authenticate
  #before_filter :account_admin,  :only => [:new, :create, :destroy]
  
  def create    
    @project = Project.new(params["project"])
    if @project.save
      flash[:success] = "Welcome to #{@project.name}"
      redirect_to :back
    else
      render 'new'
    end    
  end

  def show
    @title   = "Project"    
    @project = Project.find(params[:id])
    @account = Account.find(@project.account_id)
    @current_user = current_user    
    @command = params[:command]
    project_sign_in(@project)
    case 
      when @command == nil || @command =~ /PROJECT/i 
        @items_text = 'SHOW TEAM'
        @items_command = 'TEAM'
        @command_form_partial = nil
        @items_partial = nil
      when @command =~ /TEAM/i
        @memberships = @project.memberships.paginate(:per_page => 6, :page => params[:page])
        @items_text = 'SHOW PROJECT'
        @items_command = 'PROJECT'
        @command_form_partial = 'memberships/invite_user'
        @invited_user = Membership.new
        @items_partial = 'memberships/project_team_members_index'
      else
        @items_text = 'SHOW TEAM'
        @items_command = 'TEAM'
        @command_form_partial = nil
        @items_partial = nil
    end    
  end
  
  def edit
  end
  
  def update
    #todo implement command pattern
    project = Project.find(params[:id])
    command = params[:command]
    case command
      when "suspend" then project.suspend
      when "reinstate" then project.reinstate
    end
    redirect_to :back     
  end
  
  def destroy
  end

end

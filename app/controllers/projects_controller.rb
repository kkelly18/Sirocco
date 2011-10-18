class ProjectsController < ApplicationController
  before_filter :authenticate
  #before_filter :account_admin,  :only => [:new, :create, :destroy]
  
  def index
  end

  def new
    @project = Project.new
  end

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
    @project = Project.find(params[:id])
    @team_members = @project.team_members.paginate(:per_page => 6, :page => params[:page])
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

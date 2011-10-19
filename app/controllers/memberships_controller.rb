class MembershipsController < ApplicationController
  before_filter :authenticate

  def create
    @membership = Membership.new(params[:membership])
    @membership.user_id = User.where(:email=>@membership.user_email).first.id 
    if @membership.save!
      redirect_to :back
    end
    
  end

  def update
    #todo implement command pattern
    membership = Membership.find(params[:id])
    command = params[:command]
    case command
      when "enroll" then membership.enroll
      when "withdraw" then membership.withdraw
      when "suspend" then membership.suspend
      when "reinstate" then membership.reinstate
      when "toggle_admin" then membership.toggle!(:admin)
    end
    redirect_to :back 
  end

end
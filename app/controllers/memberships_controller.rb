class MembershipsController < ApplicationController
  before_filter :authenticate

  def create
    membership = Membership.new(params[:membership])
    if membership.save
      redirect_to :back
    end
    
  end

  def update
    #todo implement command pattern
    membership = Membership.find(params[:id])
    command = params[:command]
    case 
      when command =~ /enroll/       then membership.enroll
      when command =~ /withdraw/     then membership.withdraw
      when command =~ /suspend/      then membership.suspend
      when command =~ /reinstate/    then membership.reinstate
      when command =~ /toggle_admin/ then membership.toggle!(:admin)
    end
    redirect_to :back 
  end

end
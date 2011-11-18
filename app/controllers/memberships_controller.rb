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
    membership.current_user_id = @current_user.id
    command = params[:command]
    case
      when command =~ /uninvite/        then membership.uninvite
      when command =~ /invite/          then membership.invite 
      when command =~ /enroll/          then membership.enroll
      when command =~ /withdraw/        then membership.withdraw
      when command =~ /rejoin/          then membership.rejoin    
      when command =~ /suspend/         then membership.suspend
      when command =~ /reinstate/       then membership.reinstate
      when command =~ /remove/          then membership.remove
    end
    redirect_to :back 
  end

end
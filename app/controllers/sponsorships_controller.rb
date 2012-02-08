class SponsorshipsController < ApplicationController
  before_filter :authenticate
  
  def create
    sponsorship = Sponsorship.new(params[:sponsorship])
    sponsorship.current_user_id = sponsorship.created_by = current_user.id
    if sponsorship.save
      flash[:success] = "Added #{sponsorship.user.name}"
      redirect_to :back
    end    
  end
  
  def update
    sponsorship = Sponsorship.find(params[:id])
    sponsorship.current_user_id = @current_user.id
    command = params[:command]
    case 
      when command =~ /uninvite/  then sponsorship.uninvite
      when command =~ /invite/    then sponsorship.invite 
      when command =~ /enroll/    then sponsorship.enroll
      when command =~ /withdraw/  then sponsorship.withdraw
      when command =~ /rejoin/    then sponsorship.rejoin  
      when command =~ /suspend/   then sponsorship.suspend
      when command =~ /reinstate/ then sponsorship.reinstate
      when command =~ /remove/    then sponsorship.remove        
    end
    redirect_to :back 
  end
  
end

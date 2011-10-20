class SponsorshipsController < ApplicationController
  before_filter :authenticate
  
  def create
    @sponsorship = Sponsorship.new(params[:sponsorship])
    if @sponsorship.save
      redirect_to :back
    end    
  end
  
  
  def update
    sponsorship = Sponsorship.find(params[:id])
    command = params[:command]
    case 
      when command =~ /enroll/       then sponsorship.enroll
      when command =~ /withdraw/     then sponsorship.withdraw
      when command =~ /suspend/      then sponsorship.suspend
      when command =~ /reinstate/    then sponsorship.reinstate
      when command =~ /toggle_admin/ then sponsorship.toggle!(:admin)
    end
    redirect_to :back 
  end

  
end

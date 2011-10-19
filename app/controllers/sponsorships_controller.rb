class SponsorshipsController < ApplicationController

  def create
    @sponsorship = Sponsorship.new(params[:sponsorship])
    @sponsorship.user_id = User.where(:email=>@sponsorship.user_email).first.id 
    if @sponsorship.save!
      redirect_to :back
    end    
  end
  
  
end

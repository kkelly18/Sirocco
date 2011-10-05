class Account < ActiveRecord::Base
  attr_accessible :name, :created_by, :suspend_at
  
  has_many :sponsorships, :foreign_key => "account_id",
                        :dependent => :destroy  
                                  
  has_many :team_members, :through => :sponsorships, 
                        :source => :user  
  
  has_many :projects, :foreign_key => "account_id",
                       :dependent => :destroy
                       
  before_create :update_sponsorship
                              
  validates :name,  
            :presence => true
            
  validates :created_by,
            :presence => true
            
  def suspend
    self.suspend_at = Time.now.utc
    self.save
  end

  def suspended?
    true unless self.suspend_at == nil || self.suspend_at > Time.now.utc
  end

  def reinstate
    self.suspend_at = nil
    self.save
  end

  private
    def update_sponsorship
      self.sponsorships.build(:account_id => 1,
                                      :user_id => self.created_by, 
                                      :created_by => self.created_by,
                                      :enroll_at => Time.now.utc, 
                                      :admin => true)
      
    end
end

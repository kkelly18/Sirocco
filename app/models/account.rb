class Account < ActiveRecord::Base
  attr_accessible :name, :created_by
  
  has_many :sponsorships, :foreign_key => "account_id",
                        :dependent => :destroy  
                                  
  has_many :projects, :foreign_key => "account_id",
                       :dependent => :destroy
                       
  before_create :make_creator_a_sponsor
                              
  validates :name,  
            :presence => true
            
  validates :created_by,
            :presence => true
  
  state_machine :state, :initial => :active do
    event :suspend do
      transition :active => :suspended
    end
    event :reinstate do
      transition :suspended => :active
    end
    event :remove do
      transition :suspended => :removed
    end
    state :active do
    end
    state :suspended do
    end
    state :removed do
    end    
  end
            
  private
    def make_creator_a_sponsor
      s = self.sponsorships.build(:account_id => 1,
                                  :user_id    => self.created_by, 
                                  :created_by => self.created_by,
                                  :current_user_id => self.created_by)
      s.enroll #creating own account, so enroll thy self
      s.promote_access #creating own account, so make self admin
    end
end

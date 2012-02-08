class Project < ActiveRecord::Base
  attr_accessible :name, :created_by, :account_id
  
  has_many :memberships,          :foreign_key => "project_id",
                                  :dependent   => :destroy  
                                  
  has_many :team_members,         :through => :memberships, 
                                  :source  => :user
  
  belongs_to :accounts,           :class_name => "Account"
  
  before_create :update_membership
  
  validates :name,  
            :presence => true,
            :length   => { :maximum => 50 } #TODO: remove length constraint
            
  validates :account_id,
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
    def update_membership
      m = self.memberships.build( :project_id => 1,
                              :user_id => self.created_by, 
                              :created_by => self.created_by,
                              :current_user_id => self.created_by)
      m.enroll #creating own project, so enroll thy self
      m.promote_access #creating own project, so make self admin
    end
end

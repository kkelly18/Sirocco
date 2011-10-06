class Project < ActiveRecord::Base
  attr_accessible :name, :created_by, :account_id, :suspend_at
  
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
    def update_membership
      self.memberships.build( :project_id => 1,
                              :user_id => self.created_by, 
                              :created_by => self.created_by,
                              :enroll_at => Time.now.utc, 
                              :admin => true)
      
    end
end

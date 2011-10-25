class Sponsorship < ActiveRecord::Base
  attr_accessor :user_email #used for inviting users to projects
  attr_accessible :user_id, :account_id, :created_by, :enroll_at, :suspend_at, :admin, :user_email

  belongs_to :user,        :class_name => "User"
  belongs_to :account,     :class_name => "Account"
  
  before_validation_on_create :invite

  validates :user_id,      :presence => true
  validates :account_id,   :presence => true
  validates :created_by,   :presence => true
  
  scope :all, joins(:account).includes(:account)
  state_machine :state, :initial => :invited do
    event :enroll do
      transition :invited => :enrolled
    end
    event :suspend do
      transition :enrolled => :suspended
    end
    event :reinstate do
      transition :suspended => :enrolled
    end
    event :withdraw do
      transition :enrolled => :withdrawn
    end
    event :rejoin do
      transition :withdrawn => :enrolled
    end
    event :remove do
      transition :suspended => :removed
    end
    state :invited do
    end
    state :enrolled do
    end
    state :suspended do
    end
    state :withdrawn do
    end
    state :removed do
    end    
  end
  
  state_machine :access_state, :initial => :contributor, :namespace => 'access' do
    event :promote do
      transition :contributor => :admin
    end
    event :demote do
      transition :admin => :contributor
    end
    state :contributor do
    end
    state :admin do
    end
  end

  private
    def invite
      self.user_id = User.where(:email => "#{self.user_email}").first.id if self.user_email
    end              

end

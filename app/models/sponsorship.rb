class Sponsorship < ActiveRecord::Base
  attr_accessor :user_email #used for inviting users to projects
  attr_accessible :user_id, :account_id, :created_by, :enroll_at, :suspend_at, :admin, :user_email

  belongs_to :user,        :class_name => "User"
  belongs_to :account,     :class_name => "Account"

  validates :user_id,      :presence => true
  validates :account_id,   :presence => true
  validates :created_by,   :presence => true
  
  scope :all, joins(:account).includes(:account)

  def enroll
    self.enroll_at ||= Time.now.utc
    self.save
  end

  def enrolled?
    true if self.enroll_at && self.enroll_at <= Time.now.utc
  end

  def suspend
    self.suspend_at = Time.now.utc
    self.save
  end

  def suspended?
    true if self.suspend_at && self.suspend_at <= Time.now.utc
  end

  def reinstate
    self.suspend_at = nil
    self.save
  end

  def withdraw
    self.delete_at ||= Time.now.utc
    self.save
  end

  def invite
    #TODO handle email not found
    self.user_id = User.where(:email=>self.user_email).first.id 
  end

  def invited?
    true unless self.enroll_at || self.suspend_at || self.delete_at
  end

end

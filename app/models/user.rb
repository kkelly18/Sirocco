class User < ActiveRecord::Base
  attr_accessor   :password, :personal_account_name, :personal_account
  attr_accessible :name, :email, :password, :password_confirmation, :personal_account_name, :personal_account

  has_many :sponsorships, :foreign_key => "user_id",
  :dependent => :destroy

  has_many :accounts, :through => :sponsorships,
  :source => :account

  has_many :memberships, :foreign_key => "user_id",
                         :dependent => :destroy
                                  
  has_many :projects, :through => :memberships, 
                               :source => :project
                               

  email_regex = /\A[\w\-.]+@[a-z\d.]+\.[a-z]+\z/i

  validates :name,  
  :presence => true,
  :length   => {:maximum => 50 }

  validates :email, 
  :presence => true,
  :format   => { :with => email_regex },
  :uniqueness => { :case_sensitive => false }

  validates :password,  
  :presence => true,
  :confirmation => true,
  :length => { :within => 6..40 }

  before_save  :encrypt_password
  after_create :create_personal_account

  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end

  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end

  def account_projects(account)
    project_array = calc_account_projects(account)
    project_associations.in_the_set_of(project_array)

    #example usage 
    #project_list = current_user.account_projects (current_account)
    #project_list.each {|s| puts s.project.name}
  end

  def query_memberships(account=nil)
    if account
      project_array = calc_account_projects(account)
      return project_associations.in_the_set_of(project_array)
    else
      return project_associations.all
    end
  end

  private  

  def encrypt_password
    self.salt = make_salt unless has_password?(password)
    self.encrypted_password = encrypt(password)
  end

  def encrypt(string)
    secure_hash("#{salt}--#{string}")
  end

  def make_salt
    secure_hash("#{Time.now.utc}--#{password}")
  end

  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end

  def calc_account_projects (account)

    u = self.project_associations
    u_array = []
    u.each {|s| u_array << s.project_id}

    a = account.projects
    a_array = []
    a.each {|s| a_array << s.id}

    return a_array & u_array
  end

  def create_personal_account
    @personal_account = Account.new(:name => @personal_account_name, :created_by => self.id)
    @personal_account.save!
  end

end

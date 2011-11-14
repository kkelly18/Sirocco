class Membership < ActiveRecord::Base
  attr_accessor :user_email, #set in create, used for inviting users to projects
                :current_user_id #set in show, used for showing commands and logging acctions

  attr_accessible :user_id, :project_id, :created_by, :user_email

  belongs_to :user,        :class_name => "User"
  belongs_to :project,     :class_name => "Project"

  before_validation :on => :create do |user|
    invite
  end

  validates :user_id,      :presence => true
  validates :project_id,   :presence => true
  validates :created_by,   :presence => true

  scope :in_the_set_of, lambda {|project| where(:project_id => project).joins(:project).includes(:project)}
  scope :all, joins(:project).includes(:project)
        
  state_machine :state, :initial => :invited do
    event :uninvite do
      transition :invited => :uninvited
    end
    event :invite do
      transition :uninvited => :invited
    end
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
      transition :withdrawn => :removed
      transition :suspended => :removed
    end
    
    state :invited do
      def status
        return "Invited" unless self.project.suspended?
        return "Project Suspended" 
      end
      def commands
        a = []
        if self.project.suspended? 
          if current_user_is_account_admin?
            a << {:text       => 'Reinstate', 
                  :controller => 'projects',
                  :action     => 'update',
                  :id         => self.project_id,
                  :command    => 'reinstate'}
          end
          return a
        end         
        if current_user_is_member?
          a << {:text       => 'Enroll', 
                :controller => 'memberships',
                :action     => 'update',
                :id         =>  self.id,
                :command    => 'enroll'}
        else #if current_user is not this member and...
          if current_user_is_project_admin?
          a << {:text => 'Uninvite', 
                :controller => 'memberships',
                :action     => 'update',
                :id         =>  self.id,
                :command    => 'uninvite'}
          end
        end
        if current_user_is_account_admin?
          a << {:text       => 'Suspend', 
                :controller => 'projects',
                :action     => 'update',
                :id         => self.project_id,
                :command    => 'suspend'}
        end
        return a                          
      end
    end
    state :uninvited do
      def status
        return "Uninvited" unless self.project.suspended?
        return "Project Suspended"         
      end
      def commands
        a = []
        if self.project.suspended? 
          if current_user_is_account_admin?
            a << {:text       => 'Reinstate', 
                  :controller => 'projects',
                  :action     => 'update',
                  :id         => self.project_id,
                  :command    => 'reinstate'}
          end
          return a
        end         
        if current_user_is_project_admin? # members can'e uninvite themselves
          a << {:text       => 'Invite', 
                :controller => 'memberships',
                :action     => 'update',
                :id         =>  self.id,
                :command    => 'invite'}
        end
        if current_user_is_account_admin?
          a << {:text       => 'Suspend', 
                :controller => 'projects',
                :action     => 'update',
                :id         => self.project_id,
                :command    => 'suspend'}
        end
      return a
    end
    end
    state :enrolled do
      def status
        return "Enrolled" unless self.project.suspended?
        return "Project Suspended" 
      end
      def commands
        #depends on:
          #state of the project
          #access state of the account user
          #access state of the project user
          #whether current user is the member
        a = []
        if self.project.suspended? 
          if current_user_is_account_admin?
            a << {:text       => 'Reinstate', 
                  :controller => 'projects',
                  :action     => 'update',
                  :id         => self.project_id,
                  :command    => 'reinstate'}
          end
          return a
        end  
        
        if current_user_is_member?
          a << {:text       => 'Withdraw', 
                :controller => 'memberships',
                :action     => 'update',
                :id         =>  self.id,
                :command    => 'withdraw'}
        else #if current_user is not this member and...
          if current_user_is_project_admin?
          a << {:text => 'Suspend Member', 
                :controller => 'memberships',
                :action     => 'update',
                :id         =>  self.id,
                :command    => 'suspend'}
          end
        end
          
        if current_user_is_account_admin?
          a << {:text       => 'Suspend', 
                :controller => 'projects',
                :action     => 'update',
                :id         => self.project_id,
                :command    => 'suspend'}
        end          
        return a
      end
    end
    state :withdrawn do
      def status
        return "Withdrawn" unless self.project.suspended?
        return "Project Suspended" 
      end
      def commands
          #depends on:
            #state of the project
            #access state of the account user
            #access state of the project user
            #whether current user is the member
          a = []
          if self.project.suspended? 
            if current_user_is_account_admin?
              a << {:text       => 'Reinstate', 
                    :controller => 'projects',
                    :action     => 'update',
                    :id         => self.project_id,
                    :command    => 'reinstate'}
            end
            return a
          end  

          if current_user_is_member?
            a << {:text       => 'Rejoin', 
                  :controller => 'memberships',
                  :action     => 'update',
                  :id         =>  self.id,
                  :command    => 'rejoin'}
          else #current user is not member
            if current_user_is_project_admin?
              a << {:text       => 'Suspend membership', 
                    :controller => 'memberships',
                    :action     => 'update',
                    :id         =>  self.id,
                    :command    => 'suspend'}
            end
          end

          if current_user_is_account_admin?
            a << {:text       => 'Suspend project', 
                  :controller => 'projects',
                  :action     => 'update',
                  :id         => self.project_id,
                  :command    => 'suspend'}
          end          
          return a
        end
    end
    state :suspended do
      def status
        return "Suspended" unless self.project.suspended?
        return "Project Suspended" #not membership
      end
      def commands
        #depends on:
          #state of the project
          #access state of the account user
          #access state of the project user
          #whether current user is the member
        a = []
        if self.project.suspended? 
          if current_user_is_account_admin?
            a << {:text       => 'Reinstate project', 
                  :controller => 'projects',
                  :action     => 'update',
                  :id         => self.project_id,
                  :command    => 'reinstate'}
          end
          return a
        end  

        if current_user_is_project_admin?
          a << {:text       => 'Reinstate membership', 
                :controller => 'memberships',
                :action     => 'update',
                :id         =>  self.id,
                :command    => 'reinstate'}
        end

        if current_user_is_account_admin?
          a << {:text       => 'Suspend project', 
                :controller => 'projects',
                :action     => 'update',
                :id         => self.project_id,
                :command    => 'suspend'}
        end          
        return a
        end
    end
    state :removed do
      def status
        return "Removed" unless self.project.suspended?
        return "Project Suspended" 
      end
      def commands
        a = []
        return a
      end
    end
  end 
  
  state_machine :access_state, :initial => :observer, :namespace => 'access' do
    event :promote do
      transition :observer => :contributor, :contributor => :admin
    end
    event :demote do
      transition :admin => :contributor, :contributor => :observer
    end
    
    state :observer do
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
    def current_user_is_member?
       @current_user_id == self.user_id
    end
    def current_user_is_account_admin?
      id = self.project.account_id
      return User.find(@current_user_id).sponsorships.where(:account_id => id).first.access_admin?
    end    
    def current_user_is_project_admin?
      id = self.project_id
      return User.find(@current_user_id).memberships.where(:project_id => id).first.access_admin?
    end    
end

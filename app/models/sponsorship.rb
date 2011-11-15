class Sponsorship < ActiveRecord::Base
  attr_accessor :user_email, #set in create, used for inviting users to accounts
                :current_user_id #set in show, used for showing commands and logging actions

  attr_accessible :user_id, :account_id, :created_by, :enroll_at, :suspend_at, :admin, :user_email

  belongs_to :user,        :class_name => "User"
  belongs_to :account,     :class_name => "Account"
  
  before_validation :on => :create do |user|
    lookup_id_from_email
  end
    
  validates :user_id,      :presence => true
  validates :account_id,   :presence => true
  validates :created_by,   :presence => true
  
  scope :all, joins(:account).includes(:account)
  
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
        status_string_for_current_state
      end
      def commands
        a = []
        if self.account.suspended? 
          return reinstate_account_command if current_user_is_sys_admin?
          return a
        end         
        if current_user_is_dependent?
          a << {:text       => 'Enroll', 
                :controller => 'sponsorships',
                :action     => 'update',
                :id         =>  self.id,
                :command    => 'enroll'}
        else #if current_user is not this member and...
          if current_user_is_account_admin?
            a << {:text       => 'Uninvite', 
                  :controller => 'sponsorships',
                  :action     => 'update',
                  :id         =>  self.id,
                  :command    => 'uninvite'}
          end
        end
        a << suspend_account_command if current_user_is_sys_admin?
        return a                          
      end #end def
    end #end state
    state :uninvited do
      def status
        status_string_for_current_state
      end
      def commands
        a = []
        if self.account.suspended? 
          return reinstate_account_command if current_user_is_sys_admin?
          return a
        end         
        if current_user_is_account_admin? # members can'e uninvite themselves
          a << {:text       => 'Invite', 
                :controller => 'sponsorships',
                :action     => 'update',
                :id         =>  self.id,
                :command    => 'invite'}
        end
        a << suspend_account_command if current_user_is_sys_admin?
        return a
      end #end def
    end #end state
    state :enrolled do
      def status
        status_string_for_current_state
      end
      def commands
        a = []
        if self.account.suspended? 
          return reinstate_account_command if current_user_is_sys_admin?
          return a
        end         
        if current_user_is_dependent?
          a << {:text       => 'Withdraw', 
                :controller => 'sponsorships',
                :action     => 'update',
                :id         =>  self.id,
                :command    => 'withdraw'}
        else #if current_user is not this member and...
          if current_user_is_account_admin?
            a << {:text       => 'Suspend dependent', 
                  :controller => 'sponsorships',
                  :action     => 'update',
                  :id         =>  self.id,
                  :command    => 'suspend'}
          end
        end        
        a << suspend_account_command if current_user_is_sys_admin?
        return a
      end #end def
    end #end state
    state :suspended do
      def status
        status_string_for_current_state
      end
      def commands
        a = []
        if self.account.suspended? 
          return reinstate_account_command if current_user_is_sys_admin?
          return a
        end         
        if current_user_is_account_admin?
          a << {:text       => 'Reinstate sponsorship', 
                :controller => 'sponsorships',
                :action     => 'update',
                :id         =>  self.id,
                :command    => 'reinstate'}
        end
        a << suspend_account_command if current_user_is_sys_admin?
        return a
      end #end def
    end #end state
    state :withdrawn do
      def status
        status_string_for_current_state
      end
      def commands
        a = []
        if self.account.suspended? 
          return reinstate_account_command if current_user_is_sys_admin?
          return a
        end         
        if current_user_is_dependent?
          a << {:text       => 'Rejoin', 
                :controller => 'sponsorships',
                :action     => 'update',
                :id         =>  self.id,
                :command    => 'rejoin'}
        else #current user is not member
          if current_user_is_account_admin?
            a << {:text       => 'Suspend sponsorship', 
                  :controller => 'sponsorships',
                  :action     => 'update',
                  :id         =>  self.id,
                  :command    => 'suspend'}
          end
        end
        a << suspend_account_command if current_user_is_sys_admin?
        return a
      end #end def
    end #end state
    state :removed do
      def status
        status_string_for_current_state
      end
      def commands
        a = []
        return a
      end
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
    def lookup_id_from_email
      self.user_id = User.where(:email => "#{self.user_email}").first.id if self.user_email
    end              
    def current_user_is_dependent?
       @current_user_id == self.user_id
    end
    def current_user_is_account_admin?
      id = self.account_id
      return User.find(@current_user_id).sponsorships.where(:account_id => id).first.access_admin?
    end    
    def current_user_is_sys_admin?
      return User.find(@current_user_id).sys_admin?
    end    
    def status_string_for_current_state 
      return self.state 
    end
    def reinstate_account_command
      return [{:text       => 'Reinstate', 
               :controller => 'accounts',
               :action     => 'update',
               :id         => self.account_id,
               :command    => 'reinstate'}]      
    end
    def suspend_account_command
      return {:text       => 'Suspend', 
              :controller => 'accounts',
              :action     => 'update',
              :id         => self.account_id,
              :command    => 'suspend'}
    end

end

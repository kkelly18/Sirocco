class Membership < ActiveRecord::Base
      attr_accessor :user_email #used for inviting users to projects
      attr_accessible :user_id, :project_id, :created_by, :enroll_at, :suspend_at, :admin, :user_email

      belongs_to :user,        :class_name => "User"
      belongs_to :project,     :class_name => "Project"

      before_validation_on_create :invite

      validates :user_id,      :presence => true
      validates :project_id,   :presence => true
      validates :created_by,   :presence => true

      scope :in_the_set_of, lambda {|project| where(:project_id => project).joins(:project).includes(:project)}
      scope :all, joins(:project).includes(:project)
            
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

      def invited?
        true unless self.enroll_at || self.suspend_at || self.delete_at
      end
      
      private
        def invite
          self.user_id = User.where(:email => "#{self.user_email}").first.id if self.user_email
        end              
end

require 'spec_helper'

describe Membership do
    before(:each) do
      @current_user = @user = Factory(:user)
      @project = Factory(:project)
      @attr = {:project_id  => @project.id, 
        :user_id     => @user.id, 
        :created_by  => @current_user.id}
      end

      it "should create a new instance from a User given valid attributes"  do    
        new_membership = @user.memberships.create!(@attr)
        new_membership.should be_valid
      end

      describe "validations," do

        it "should New one up with valid attributes" do
          Membership.new(@attr).should be_valid
        end

        it "should not new one up without an project" do
          @attr[:project_id] = nil
          Membership.new(@attr).should_not be_valid
        end

        it "should not new one up without a user" do
          @attr[:user_id] = nil
          Membership.new(@attr).should_not be_valid
        end    

        it "should not New one up without setting created_by" do
          @attr[:created_by] = nil
          Membership.new(@attr).should_not be_valid
        end
      end  # validations

      describe "state machine" do
        before (:each) do
          @membership = @user.memberships.create!(@attr)
        end
        it "should be set to invited by default" do
          @membership.should be_invited
        end
        
        it "should be uninvited" do
          @membership.uninvite
          @membership.should be_uninvited
        end
        
        it "should be invited" do
          @membership.uninvite
          @membership.invite
          @membership.should be_invited
        end      

        it "should be enrolled" do
          @membership.enroll
          @membership.should be_enrolled
        end

        it "should be suspendable" do
          @membership.enroll
          @membership.suspend
          @membership.should be_suspended
        end    

        it "should be reinstated once suspended" do
          @membership.enroll
          @membership.suspend
          @membership.reinstate
          @membership.should be_enrolled
        end

        it "should be removed" do
          @membership.enroll
          @membership.suspend
          @membership.remove
          @membership.should be_removed
        end
      end
      
      describe "access state machine" do
        before (:each) do
          @membership = @user.memberships.create!(@attr)
        end

        it "should be set to observer by default" do
          @membership.should be_access_observer
        end    

        it "should be set from observer to contributor" do
          @membership.promote_access
          @membership.should be_access_contributor
        end

        it "should be set from contributor to observer" do
          @membership.promote_access
          @membership.should be_access_contributor
          @membership.demote_access
          @membership.should be_access_observer          
        end

        it "should be set from contributor to admin" do
          @membership.promote_access
          @membership.promote_access
          @membership.should be_access_admin
        end
        
        it "should be set from admin to contributor" do
          @membership.promote_access
          @membership.promote_access
          @membership.should be_access_admin
          @membership.demote_access
          @membership.demote_access
          @membership.should be_access_observer          
        end        

        it "should be admin when promoting past the end" do
          @membership.promote_access
          @membership.promote_access
          @membership.promote_access
          @membership.should be_access_admin          
        end        

        it "should be observer when demoting past the start" do
          @membership.demote_access
          @membership.should be_access_observer          
        end        
      end
      
      describe "methods" do

        before (:each) do
          @membership = @user.memberships.create!(@attr)
        end

        describe "Membership#user" do
          it "should have a member attribute" do
            @membership.should respond_to(:user)
          end

          it "should have the right member" do
            @membership.user.should == @user
          end
        end

        describe "Membership#project" do
          it "should have project attribute" do
            @membership.should respond_to(:project)
          end

          it "should have the right project" do
            @membership.project.should == @project
          end
        end
      end #methods
      
    end    

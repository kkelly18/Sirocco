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

        describe "Membership#enroll" do
          it "should have attribute: Membership#enroll" do
            @membership.should respond_to(:enroll)
          end

          it "should set the enroll_at datetime" do
            @membership.enroll_at.should be_nil
            @membership.enroll
            @membership = @user.memberships.find_by_project_id(@project)
            @membership.enroll_at.should_not be_nil
            @membership.enroll_at.should be <= Time.now.utc
          end
        end

        describe "Membership#enrolled?" do
          it "should have attribute: Membership#enrolled?" do
            @membership.should respond_to(:enrolled?)
          end

          it "should return correct boolean" do
            @membership.should_not be_enrolled
            @membership.enroll
            @membership = @user.memberships.find_by_project_id(@project)
            @membership.should be_enrolled
          end
        end

        describe "Membership#suspend" do
          it "should have member attribute: Membership#suspend" do
            @membership.should respond_to(:suspend)
          end    

          it "should set the suspend_at datetime" do
            @membership.suspend_at.should be_nil
            @membership.suspend
            @membership = @user.memberships.find_by_project_id(@project)
            @membership.suspend_at.should_not be_nil
            @membership.suspend_at.should be <= Time.now.utc
          end      
        end

        describe "Membership#supended?" do
          it "should have member attribute: Membership#suspended?" do
            @membership.should respond_to(:suspended?)
          end    

          it "should return correct boolean" do
            @membership.should_not be_suspended
            @membership.suspend
            @membership = @user.memberships.find_by_project_id(@project)
            @membership.should be_suspended
          end
        end

        describe "Membership#reinstate" do
          it "should have member attribute: Membership#reinstate" do
            @membership.should respond_to(:reinstate)
          end    

          it "should set the suspend_at datetime to nil" do
            @attr[:suspend_at] = Time.now.utc
            @membership = @user.memberships.create!(@attr)
            @membership.suspend_at.should_not be_nil
            @membership.reinstate
            @membership = @user.memberships.find_by_project_id(@project)
            @membership.suspend_at.should be_nil
          end
        end

        describe "Membership#withdraw" do
          it "should have member attribute: Membership#withdraw" do
            @membership.should respond_to(:withdraw)
          end    

          it "should set the delete_at datetime" do
            @membership.delete_at.should be_nil
            @membership.withdraw
            @membership = @user.memberships.find_by_project_id(@project)
            @membership.delete_at.should_not be_nil
            @membership.delete_at.should be <= Time.now.utc
          end      
        end

        describe "Membership#invited?" do
          it "should respond" do
            @membership.should respond_to(:invited?)
          end

          it "should return true if not enrolled, suspended or deleted" do
            @membership.should be_invited
          end        

          it "should return false if enrolled, suspended or deleted" do
            @attr[:enroll_at] = Time.now.utc
            @membership = Membership.create!(@attr)
            @membership.should_not be_invited
          end
        end

      end #methods
    end    

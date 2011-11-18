require 'spec_helper'

describe Sponsorship do

  before(:each) do
    @current_user = @user = Factory(:user)
    @account = Factory(:account)
    @attr = {:account_id      => @account.id, 
             :user_id         => @user.id, 
             :created_by      => @current_user.id,
             :current_user_id => @current_user.id}
    end

    it "should create a new instance from a User given valid attributes"  do    
      new_sponsorship = @user.sponsorships.create!(@attr)
      new_sponsorship.should be_valid
    end

    describe "validations," do

      it "should New one up with valid attributes" do
        Sponsorship.new(@attr).should be_valid
      end

      it "should not new one up without an account" do
        @attr[:account_id] = nil
        Sponsorship.new(@attr).should_not be_valid
      end

      it "should not new one up without a user" do
        @attr[:user_id] = nil
        Sponsorship.new(@attr).should_not be_valid
      end    

      it "should not New one up without setting created_by" do
        @attr[:created_by] = nil
        Sponsorship.new(@attr).should_not be_valid
      end
    end  # validations

    describe "state machine" do
      before (:each) do
        @sponsorship = @user.sponsorships.create!(@attr)
      end
      it "should be set to invited by default" do
        @sponsorship.should be_invited
      end    

      it "should be uninvited" do
        @sponsorship.uninvite
        @sponsorship.should be_uninvited
      end
      
      it "should be invited" do
        @sponsorship.uninvite
        @sponsorship.invite
        @sponsorship.should be_invited
      end      

      it "should be enrolled" do
        @sponsorship.enroll
        @sponsorship.should be_enrolled
      end

      it "should be suspendable" do
        @sponsorship.enroll
        @sponsorship.suspend
        @sponsorship.should be_suspended
      end    

      it "should be reinstated once suspended" do
        @sponsorship.enroll
        @sponsorship.suspend
        @sponsorship.reinstate
        @sponsorship.should be_enrolled
      end

      it "should be removed" do
        @sponsorship.enroll
        @sponsorship.suspend
        @sponsorship.remove
        @sponsorship.should be_removed
      end
    end
    
    describe "access state machine" do
      before (:each) do
        @sponsorship = @user.sponsorships.create!(@attr)
      end

      it "should be set to contributor by default" do
        @sponsorship.should be_access_contributor
      end    

      it "should be set from contributor to admin" do
        @sponsorship.promote_access
        @sponsorship.should be_access_admin
      end
      
      it "should be set from admin to contributor" do
        @sponsorship.promote_access
        @sponsorship.should be_access_admin
        @sponsorship.demote_access
        @sponsorship.should be_access_contributor
      end        

      it "should be admin when promoting past the end" do
        @sponsorship.promote_access
        @sponsorship.promote_access
        @sponsorship.should be_access_admin          
      end        

      it "should be contributor when demoting past the start" do
        @sponsorship.demote_access
        @sponsorship.should be_access_contributor          
      end        
    end
    
    describe "methods" do

      before (:each) do
        @sponsorship = @user.sponsorships.create!(@attr)
      end

      describe "Sponsorship#user" do
        it "should have a member attribute" do
          @sponsorship.should respond_to(:user)
        end

        it "should have the right member" do
          @sponsorship.user.should == @user
        end
      end

      describe "Sponsorship#account" do
        it "should have account attribute" do
          @sponsorship.should respond_to(:account)
        end

        it "should have the right account" do
          @sponsorship.account.should == @account
        end
      end

    end #methods
  end    

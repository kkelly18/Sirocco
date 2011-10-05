require 'spec_helper'

describe Sponsorship do

  before(:each) do
    @current_user = @user = Factory(:user)
    @account = Factory(:account)
    @attr = {:account_id  => @account.id, 
      :user_id     => @user.id, 
      :created_by  => @current_user.id}
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

      describe "Sponsorship#enroll" do
        it "should have attribute: Sponsorship#enroll" do
          @sponsorship.should respond_to(:enroll)
        end

        it "should set the enroll_at datetime" do
          @sponsorship.enroll_at.should be_nil
          @sponsorship.enroll
          @sponsorship = @user.sponsorships.find_by_account_id(@account)
          @sponsorship.enroll_at.should_not be_nil
          @sponsorship.enroll_at.should be <= Time.now.utc
        end
      end

      describe "Sponsorship#enrolled?" do
        it "should have attribute: Sponsorship#enrolled?" do
          @sponsorship.should respond_to(:enrolled?)
        end

        it "should return correct boolean" do
          @sponsorship.should_not be_enrolled
          @sponsorship.enroll
          @sponsorship = @user.sponsorships.find_by_account_id(@account)
          @sponsorship.should be_enrolled
        end
      end

      describe "Sponsorship#suspend" do
        it "should have member attribute: Sponsorship#suspend" do
          @sponsorship.should respond_to(:suspend)
        end    

        it "should set the suspend_at datetime" do
          @sponsorship.suspend_at.should be_nil
          @sponsorship.suspend
          @sponsorship = @user.sponsorships.find_by_account_id(@account)
          @sponsorship.suspend_at.should_not be_nil
          @sponsorship.suspend_at.should be <= Time.now.utc
        end      
      end

      describe "Sponsorship#supended?" do
        it "should have member attribute: Sponsorship#suspended?" do
          @sponsorship.should respond_to(:suspended?)
        end    

        it "should return correct boolean" do
          @sponsorship.should_not be_suspended
          @sponsorship.suspend
          @sponsorship = @user.sponsorships.find_by_account_id(@account)
          @sponsorship.should be_suspended
        end
      end

      describe "Sponsorship#reinstate" do
        it "should have member attribute: Sponsorship#reinstate" do
          @sponsorship.should respond_to(:reinstate)
        end    

        it "should set the suspend_at datetime to nil" do
          @attr[:suspend_at] = Time.now.utc
          @sponsorship = @user.sponsorships.create!(@attr)
          @sponsorship.suspend_at.should_not be_nil
          @sponsorship.reinstate
          @sponsorship = @user.sponsorships.find_by_account_id(@account)
          @sponsorship.suspend_at.should be_nil
        end
      end

      describe "Sponsorship#withdraw" do
        it "should have member attribute: Sponsorship#withdraw" do
          @sponsorship.should respond_to(:withdraw)
        end    

        it "should set the delete_at datetime" do
          @sponsorship.delete_at.should be_nil
          @sponsorship.withdraw
          @sponsorship = @user.sponsorships.find_by_account_id(@account)
          @sponsorship.delete_at.should_not be_nil
          @sponsorship.delete_at.should be <= Time.now.utc
        end      
      end

    end #methods
  end    

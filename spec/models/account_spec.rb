require 'spec_helper'

describe Account do

  before(:each) do
    @current_user = @user = Factory(:user)
    @attr = {:name        => "Good Account", 
             :created_by  => @current_user.id}
  end

  it "should create an Account given valid parameters" do
    Account.create!(@attr).should be_valid
  end

  describe "validators" do

    it "require a name" do
      @attr[:name] = nil
      Account.new(@attr).should_not be_valid
    end

    it "require created_by" do
      @attr[:created_by] = nil
      Account.new(@attr).should_not be_valid
    end
  end #validators

  describe "methods" do

    before(:each) do
      @account = Account.create!(@attr)
    end

    it "should include: Account#sponsorships" do
      @account.should respond_to(:sponsorships)
    end    
    it "should include: Account#team_members" do
      @account.should respond_to(:team_members)
    end    
    it "should include: Account#project" do
      @account.should respond_to(:projects)
    end    
    it "should include: Account#suspend" do
      @account.should respond_to(:suspend)
    end    
    it "should include: Account#suspended?" do
      @account.should respond_to(:suspended?)
    end    
    it "should include: Account#reinstate" do
      @account.should respond_to(:reinstate)
    end    

    describe "Account#projects"
    it "should return projects associated to this account" do
      project_attr = {:name        => "Alpha", 
                      :created_by  => @current_user.id, 
                      :account_id  => @account.id }
      Project.create!(project_attr)              

      project_attr[:name]= "Beta"
      Project.create!(project_attr)

      @account.projects.should have(2).items
    end
    
    describe "Account#suspend" do
      it "should set the suspend_at datetime" do
        @account.suspend_at.should be_nil
        @account.suspend
        @account.suspend_at.should_not be_nil
        @account.suspend_at.should be <= Time.now.utc
      end
    end
    
    describe "Account#suspend?" do
      it "should return correct boolean" do
        @account.should_not be_suspended
        @account.suspend
        @account.should be_suspended
      end
    end
    
    describe "Account#reinstate" do
      it "should set the suspend_at datetime to nil" do
        @attr[:suspend_at] = Time.now.utc
        @account = Account.create!(@attr)
        @account.suspend_at.should_not be_nil
        @account.reinstate
        @account.suspend_at.should be_nil
      end
    end
  end #methods
end

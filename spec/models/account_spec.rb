require 'spec_helper'

describe Account do

  before(:each) do
    @current_user = @account = Factory(:user)
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
  
  describe "state_machine" do

    before(:each) do
      @account = Account.create!(@attr)
    end
        
    it "should be set to active by default" do
      @account.should be_active
    end    

    it "should be suspendable" do
      @account.suspend
      @account.should be_suspended
    end    
    
    it "should be reinstated once suspended" do
      @account.suspend
      @account.should be_suspended
      @account.reinstate
      @account.should be_active
    end

    it "should be removed" do
      @account.suspend
      @account.remove
      @account.should be_removed
    end

  end
  

  describe "methods" do

    before(:each) do
      @account = Account.create!(@attr)
    end

    it "should include: Account#sponsorships" do
      @account.should respond_to(:sponsorships)
    end    
    it "should include: Account#project" do
      @account.should respond_to(:projects)
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
        
  end #methods
end

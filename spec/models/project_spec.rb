require 'spec_helper'

describe Project do

  before(:each) do
    @current_user = @user = Factory(:user)
    @project = Factory(:account)
    @attr = {:name        => "Good Project", 
             :created_by  => @current_user.id, 
             :account_id  => @project.id}
  end

  it "should create a new Project given valid parameters" do
    Project.create!(@attr).should be_valid
  end

  it "should New up a Project given valid parameters" do
    Project.new(@attr).should be_valid
  end

  it "validator should require a name" do
    @attr[:name] = nil
    Project.new(@attr).should_not be_valid
  end
    
  it "validator should require an account" do
    @attr[:account_id] = nil
    Project.new(@attr).should_not be_valid
  end

  it "validator should require created_by" do
    @attr[:created_by] = nil
    Project.new(@attr).should_not be_valid
  end

  describe "state_machine" do

    before(:each) do
      @project = Project.create!(@attr)
    end
        
    it "should be set to active by default" do
      @project.should be_active
    end    

    it "should be suspendable" do
      @project.suspend
      @project.should be_suspended
    end    
    
    it "should be reinstated once suspended" do
      @project.suspend
      @project.should be_suspended
      @project.reinstate
      @project.should be_active
    end

    it "should be removed" do
      @project.suspend
      @project.remove
      @project.should be_removed
    end

  end
  
  describe "methods" do
   
    before (:each) do
      @project = Project.create!(@attr)
    end
    
    it "should include Project#memberships" do
      @project.should respond_to(:memberships)
    end
    it "should include Project#team_members" do
      @project.should respond_to(:team_members)
    end
    
  end #method

end

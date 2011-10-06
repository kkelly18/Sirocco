require 'spec_helper'

describe Project do

  before(:each) do
    @current_user = @user = Factory(:user)
    @account = Factory(:account)
    @attr = {:name        => "Good Project", 
             :created_by  => @current_user.id, 
             :account_id  => @account.id}
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
    it "should include Project#suspend" do
      @project.should respond_to(:suspend)
    end
    it "should include Project#suspended?" do
      @project.should respond_to(:suspended?)
    end
    it "should include Project#reinstate" do
      @project.should respond_to(:reinstate)
    end                
    
    describe "Project#suspend" do
      it "should set suspend_at datetime" do
        @project = Project.create!(@attr)
        @project.suspend_at.should be_nil
        @project.suspend
        @project.suspend_at.should_not be_nil
        @project.suspend_at.should be <= Time.now.utc
      end
    end
    
    describe "Project#suspend?" do
      it "should return correct boolean" do
        @project = Project.create!(@attr)
        @project.should_not be_suspended
        @project.suspend
        @project.should be_suspended
      end
    end    
    
    describe "Project#reinstate" do
      it "should set suspend_at datetime to nil" do
        @attr[:suspend_at] = Time.now.utc
        @project = Project.create!(@attr)
        @project.suspend_at.should_not be_nil
        @project.reinstate
        @project.suspend_at.should be_nil
      end
    end        
  end #method

end

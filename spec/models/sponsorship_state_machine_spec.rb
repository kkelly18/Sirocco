require 'spec_helper'

describe "Sponsorship status and commands" do
  before(:each) do
    @user = create_user
    @account = create_account(@user)
  end

  describe "when current_user is the dependent and" do
    before(:each) do
      @current_user = @user
      @sponsorship = create_sponsorship(@account, @user, @current_user)
      @sponsored_project = create_sponsored_project(@account, @current_user)
      @sponsorship.current_user_id = @current_user.id
    end

    describe "where the dependent is invited" do
      before(:each) do
        #nothing
      end
      it "'Status' should return 'Invited'" do
        @sponsorship.should be_invited
        @sponsorship.status.should =~ /invited/i
      end
      it "'commands' should return 'enroll'" do
        c = @sponsorship.commands
        c.should have(1).item
        c.first[:command].should =~ /enroll/
      end
    end
    describe "where the dependent is uninvited" do
      before(:each) do
        @sponsorship.uninvite
      end
      it "'Status' should return 'Uninvited'" do
        @sponsorship.should be_uninvited
        @sponsorship.status.should =~ /uninvited/i
      end
      it "'commands' should return nothing" do
        c = @sponsorship.commands
        c.should be_empty
      end
    end
    describe "where the dependent is enrolled" do
      before(:each) do
        @sponsorship.enroll
      end
      it "'Status' should return 'Invited'" do
        @sponsorship.should be_enrolled
        @sponsorship.status.should =~ /enrolled/i
      end
      it "'commands' should return 'enroll'" do
        c = @sponsorship.commands
        c.should have(1).item
        c.first[:command].should =~ /withdraw/
      end
    end
    describe "where the dependent is suspended" do
      before(:each) do
        @sponsorship.enroll
        @sponsorship.suspend
      end
      it "'Status' should return 'Enrolled'" do
        @sponsorship.should be_suspended
        @sponsorship.status.should =~ /suspended/i
      end
      it "'commands' should return nothing" do
        c = @sponsorship.commands
        c.should be_empty
      end
    end
    describe "where the dependent is withdrawn" do
      before(:each) do
        @sponsorship.enroll
        @sponsorship.withdraw
      end
      it "'Status' should return 'Withdrawn'" do
        @sponsorship.should be_withdrawn
        @sponsorship.status.should =~ /withdrawn/i
      end
      it "'commands' should return 'rejoin'" do
        c = @sponsorship.commands
        c.should have(1).item
        c.first[:command].should =~ /rejoin/
      end
    end
    describe "where the dependent is removed" do
      before(:each) do
        @sponsorship.enroll
        @sponsorship.withdraw
        @sponsorship.remove
      end
      it "'Status' should return 'Removed'" do
        @sponsorship.should be_removed
        @sponsorship.status.should =~ /removed/i
      end
      it "'commands' should return nothing" do
        c = @sponsorship.commands
        c.should be_empty
      end
    end
  end

  describe "when current_user is the dependent and account is suspended and" do
    before(:each) do
      @current_user = @user
      @sponsorship = create_sponsorship(@account, @user, @current_user)
      @sponsored_project = create_sponsored_project(@account, @current_user)
      @sponsored_project.suspend #suspend
      @sponsorship = create_membership(@sponsored_project, @user, @current_user)
      @sponsorship.current_user_id = @current_user.id
    end

    describe "where the dependent is invited" do
      before(:each) do
        #nothing
      end
      it "'Status' should return 'suspended'" do
        @sponsorship.should be_invited
        @sponsorship.status.should =~ /Project Suspended/i
      end
      it "'commands' should return nothing" do
        c = @sponsorship.commands
        c.should be_empty
      end
    end
    describe "where the dependent is uninvited" do
      before(:each) do
        @sponsorship.uninvite
      end
      it "'Status' should return 'suspended'" do
        @sponsorship.should be_uninvited
        @sponsorship.status.should =~ /suspended/i
      end
      it "'commands' should return nothing" do
        c = @sponsorship.commands
        c.should be_empty
      end
    end
    describe "where the dependent is enrolled" do
      before(:each) do
        @sponsorship.enroll
      end
      it "'Status' should return 'suspended'" do
        @sponsorship.should be_enrolled
        @sponsorship.status.should =~ /suspended/i
      end
      it "'commands' should return nothing" do
        c = @sponsorship.commands
        c.should be_empty
      end
    end
    describe "where the dependent is suspended" do
      before(:each) do
        @sponsorship.enroll
        @sponsorship.suspend
      end
      it "'Status' should return 'suspended'" do
        @sponsorship.should be_suspended
        @sponsorship.status.should =~ /suspended/i
      end
      it "'commands' should return nothing" do
        c = @sponsorship.commands
        c.should be_empty
      end
    end
    describe "where the dependent is withdrawn" do
      before(:each) do
        @sponsorship.enroll
        @sponsorship.withdraw
      end
      it "'Status' should return 'suspended'" do
        @sponsorship.should be_withdrawn
        @sponsorship.status.should =~ /suspended/i
      end
      it "'commands' should return nothing" do
        c = @sponsorship.commands
        c.should be_empty
      end
    end
    describe "where the dependent is removed" do
      before(:each) do
        @sponsorship.enroll
        @sponsorship.withdraw
        @sponsorship.remove
      end
      it "'Status' should return 'suspended'" do
        @sponsorship.should be_removed
        @sponsorship.status.should =~ /suspended/i
      end
      it "'commands' should return nothing" do
        c = @sponsorship.commands
        c.should be_empty
      end
    end
  end

  describe "when current_user is the dependent and a account admin and" do
    before(:each) do
      @current_user = @user
      @sponsorship = create_sponsorship(@account, @user, @current_user)
      @sponsorship.promote_access #make accont admin
      @sponsored_project = create_sponsored_project(@account, @current_user)
      @sponsorship = create_membership(@sponsored_project, @user, @current_user)
      @sponsorship.current_user_id = @current_user.id
    end

    describe "where the dependent is invited" do
      before(:each) do
        #nothing
      end
      it "'Status' should return 'Invited'" do
        @sponsorship.should be_invited
        @sponsorship.status.should =~ /invited/i
      end
      it "'commands' should return 'enroll' and 'suspend'" do
        c = @sponsorship.commands
        c.should have(2).items
        c[0][:command].should =~ /enroll/
        c[1][:command].should =~ /suspend/
      end
    end
    describe "where the dependent is uninvited" do
      before(:each) do
        @sponsorship.uninvite
      end
      it "'Status' should return 'Uninvited'" do
        @sponsorship.should be_uninvited
        @sponsorship.status.should =~ /uninvited/i
      end
      it "'commands' should return 'suspend'" do
        c = @sponsorship.commands
        c.should have(1).items
        c[0][:command].should =~ /suspend/
      end
    end
    describe "where the dependent is enrolled" do
      before(:each) do
        @sponsorship.enroll
      end
      it "'Status' should return 'Enrolled'" do
        @sponsorship.should be_enrolled
        @sponsorship.status.should =~ /enrolled/i
      end
      it "'commands' should return 'withdraw' and 'suspend'" do
        c = @sponsorship.commands
        c.should have(2).item
        c[0][:command].should =~ /withdraw/
        c[1][:command].should =~ /suspend/
      end
    end
    describe "where the dependent is suspended" do
      before(:each) do
        @sponsorship.enroll
        @sponsorship.suspend
      end
      it "'Status' should return 'Suspended'" do
        @sponsorship.should be_suspended
        @sponsorship.status.should =~ /suspended/i
      end
      it "'commands' should return 'suspend'" do
        c = @sponsorship.commands
        c.should have(1).item
        c.first[:command].should =~ /suspend/ #suspend project
      end
    end
    describe "where the dependent is withdrawn" do
      before(:each) do
        @sponsorship.enroll
        @sponsorship.withdraw
      end
      it "'Status' should return 'Withdrawn'" do
        @sponsorship.should be_withdrawn
        @sponsorship.status.should =~ /withdrawn/i
      end
      it "'commands' should return 'rejoin' and 'suspend'" do
        c = @sponsorship.commands
        c.should have(2).items
        c[0][:command].should =~ /rejoin/
        c[1][:command].should =~ /suspend/
      end
    end
    describe "where the dependent is removed" do
      before(:each) do
        @sponsorship.enroll
        @sponsorship.withdraw
        @sponsorship.remove
      end
      it "'Status' should return 'Removed'" do
        @sponsorship.should be_removed
        @sponsorship.status.should =~ /removed/i
      end
      it "'commands' should return nothing" do
        c = @sponsorship.commands
        c.should be_empty
      end
    end
  end

  describe "when current_user is the dependent and a account admin and account is suspended and" do
    before(:each) do
      @current_user = @user
      @sponsorship = create_sponsorship(@account, @user, @current_user)
      @sponsorship.promote_access #make account admin
      @sponsored_project = create_sponsored_project(@account, @current_user)
      @sponsorship = create_membership(@sponsored_project, @user, @current_user)
      promote_to_admin(@sponsorship) #make project admin
      @sponsorship.current_user_id = @current_user.id
    end

    describe "where the dependent is invited" do
      before(:each) do
        #nothing
      end
      it "'Status' should return 'Invited'" do
        @sponsorship.should be_invited
        @sponsorship.status.should =~ /invited/i
      end
      it "'commands' should return 'enroll' and 'suspend'" do
        c = @sponsorship.commands
        c.should have(2).items
        c[0][:command].should =~ /enroll/
        c[1][:command].should =~ /suspend/  #suspend project
      end
    end
    describe "where the dependent is uninvited" do
      before(:each) do
        @sponsorship.uninvite
      end
      it "'Status' should return 'Uninvited'" do
        @sponsorship.should be_uninvited
        @sponsorship.status.should =~ /uninvited/i
      end
      it "'commands' should return 'suspend'" do
        c = @sponsorship.commands
        c.should have(2).items
        c[0][:command].should =~ /invite/
        c[1][:command].should =~ /suspend/
      end
    end
    describe "where the dependent is enrolled" do
      before(:each) do
        @sponsorship.enroll
      end
      it "'Status' should return 'Enrolled'" do
        @sponsorship.should be_enrolled
        @sponsorship.status.should =~ /enrolled/i
      end
      it "'commands' should return 'withdraw' and 'suspend'" do
        c = @sponsorship.commands
        c.should have(2).item
        c[0][:command].should =~ /withdraw/
        c[1][:command].should =~ /suspend/
      end
    end
    describe "where the dependent is suspended" do
      before(:each) do
        @sponsorship.enroll
        @sponsorship.suspend
      end
      it "'Status' should return 'Suspended'" do
        @sponsorship.should be_suspended
        @sponsorship.status.should =~ /suspended/i
      end
      it "'commands' should return nothing" do
        c = @sponsorship.commands
        c.should have(2).item
        c[0][:command].should =~ /reinstate/ #membership
        c[1][:command].should =~ /suspend/ #suspend project
      end
    end
    describe "where the dependent is withdrawn" do
      before(:each) do
        @sponsorship.enroll
        @sponsorship.withdraw
      end
      it "'Status' should return 'Withdrawn'" do
        @sponsorship.should be_withdrawn
        @sponsorship.status.should =~ /withdrawn/i
      end
      it "'commands' should return 'rejoin' and 'suspend'" do
        c = @sponsorship.commands
        c.should have(2).items
        c[0][:command].should =~ /rejoin/
        c[1][:command].should =~ /suspend/
      end
    end
    describe "where the dependent is removed" do
      before(:each) do
        @sponsorship.enroll
        @sponsorship.withdraw
        @sponsorship.remove
      end
      it "'Status' should return 'Removed'" do
        @sponsorship.should be_removed
        @sponsorship.status.should =~ /removed/i
      end
      it "'commands' should return nothing" do
        c = @sponsorship.commands
        c.should be_empty
      end
    end
  end

  describe "when current_user is not the dependent and" do
    before(:each) do
      @current_user             = create_user
      @user_sponsorship         = create_sponsorship(@account, @user, @current_user)
      @current_user_sponsorship = create_sponsorship(@account, @current_user, @current_user)
      @sponsored_project        = create_sponsored_project(@account, @current_user)
      @current_user_membership = create_membership(@sponsored_project, @current_user, @current_user)
      promote_to_admin(@current_user_membership)
      @sponsorship = create_membership(@sponsored_project, @user, @current_user)
      @sponsorship.current_user_id = @current_user.id #different current user
    end

    describe "where the dependent is invited" do
      before(:each) do
        #nothing
      end
      it "'Status' should return 'Invited'" do
        @sponsorship.should be_invited
        @sponsorship.status.should =~ /invited/i
      end
      it "'Commands' should return 'uninvite'" do
        c = @sponsorship.commands      
        c.should have(1).item
        c.first[:command].should =~ /uninvite/
      end
    end
    describe "where the dependent is uninvited" do
      before(:each) do
        @sponsorship.uninvite
      end
      it "'Status' should return 'Invited'" do
        @sponsorship.should be_uninvited
        @sponsorship.status.should =~ /uninvited/i
      end
      it "'Commands' should return 'invite'" do
        c = @sponsorship.commands      
        c.should have(1).item
        c.first[:command].should =~ /invite/
      end
    end
    describe "where the dependent is enrolled" do
      before(:each) do
        @sponsorship.enroll
      end
      it "'Status' should return 'Enrolled'" do
        @sponsorship.should be_enrolled
        @sponsorship.status.should =~ /enrolled/i
      end
      it "'Commands' should return 'suspend'" do
        c = @sponsorship.commands      
        c.should have(1).item
        c.first[:command].should =~ /suspend/
      end
    end
    describe "where the dependent is suspended" do
      before(:each) do
        @sponsorship.enroll
        @sponsorship.suspend
      end
      it "'Status' should return 'Suspended'" do
        @sponsorship.should be_suspended
        @sponsorship.status.should =~ /suspended/i
      end
      it "'Commands' should return 'reinstate'" do
        c = @sponsorship.commands      
        c.should have(1).item
        c.first[:command].should =~ /reinstate/
      end
    end
    describe "where the dependent is withdrawn" do
      before(:each) do
        @sponsorship.enroll
        @sponsorship.withdraw
      end
      it "'Status' should return 'Withdrawn'" do
        @sponsorship.should be_withdrawn
        @sponsorship.status.should =~ /withdrawn/i
      end
      it "'Commands' should return 'suspend'" do
        c = @sponsorship.commands      
        c.should have(1).item
        c.first[:command].should =~ /suspend/
      end
    end
    describe "where the dependent is removed" do
      before(:each) do
        @sponsorship.enroll
        @sponsorship.suspend
        @sponsorship.remove
      end
      it "'Status' should return 'Removed'" do
        @sponsorship.should be_removed
        @sponsorship.status.should =~ /removed/i
      end
      it "'Commands' should return nothing" do
        c = @sponsorship.commands      
        c.should be_empty
      end
    end
  end

  describe "when current_user is not the dependent and account is suspended and" do
  end

  describe "when current_user is not the dependent but is account admin and" do
    before(:each) do
      @current_user             = create_user
      @user_sponsorship         = create_sponsorship(@account, @user, @current_user)
      @current_user_sponsorship = create_sponsorship(@account, @current_user, @current_user)
      @current_user_sponsorship.promote_access #account admin
      @sponsored_project        = create_sponsored_project(@account, @current_user)
      @current_user_membership = create_membership(@sponsored_project, @current_user, @current_user)
      @sponsorship = create_membership(@sponsored_project, @user, @current_user)
      @sponsorship.current_user_id = @current_user.id #different current user
    end

    describe "where the dependent is invited" do
      before(:each) do
      end
      it "'Status' should return 'Invited'" do
        @sponsorship.should be_invited
        @sponsorship.status.should =~ /invited/i
      end
      it "'Commands' should only return 'suspend'" do
        c = @sponsorship.commands    
        c.should have(1).items
        c[0][:command].should =~ /suspend/ #suspend project
      end
    end
    describe "where the dependent is uninvited" do
      before(:each) do
        @sponsorship.uninvite
      end
      it "'Status' should return 'Uninvited'" do
        @sponsorship.should be_uninvited
        @sponsorship.status.should =~ /uninvited/i
      end
      it "'Commands' should only return 'suspend'" do
        c = @sponsorship.commands    
        c.should have(1).items
        c[0][:command].should =~ /suspend/ #suspend project
      end
    end
    describe "where the dependent is enrolled" do
      before(:each) do
        @sponsorship.enroll
      end
      it "'Status' should return 'Enrolled'" do
        @sponsorship.should be_enrolled
        @sponsorship.status.should =~ /enrolled/i
      end
      it "'Commands' should only return 'suspend'" do
        c = @sponsorship.commands    
        c.should have(1).items
        c[0][:command].should =~ /suspend/ #suspend project
      end
    end
    describe "where the dependent is suspended" do
      before(:each) do
        @sponsorship.enroll
        @sponsorship.suspend
      end
      it "'Status' should return 'Suspended'" do
        @sponsorship.should be_suspended
        @sponsorship.status.should =~ /suspended/i
      end
      it "'Commands' should only return 'suspend'" do
        c = @sponsorship.commands    
        c.should have(1).items
        c[0][:command].should =~ /suspend/ #suspend project
      end
    end
    describe "where the dependent is withdrawn" do
      before(:each) do
        @sponsorship.enroll
        @sponsorship.withdraw
      end
      it "'Status' should return 'Withdrawn'" do
        @sponsorship.should be_withdrawn
        @sponsorship.status.should =~ /withdrawn/i
      end
      it "'Commands' should only return 'suspend'" do
        c = @sponsorship.commands    
        c.should have(1).items
        c[0][:command].should =~ /suspend/ #suspend project
      end
    end
    describe "where the dependent is removed" do
      before(:each) do
        @sponsorship.enroll
        @sponsorship.suspend
        @sponsorship.remove
      end
      it "'Status' should return 'Removed'" do
        @sponsorship.should be_removed
        @sponsorship.status.should =~ /removed/i
      end
      it "'Commands' should only return 'nothing'" do
        c = @sponsorship.commands    
        c.should be_empty
      end
    end
  end

  describe "when current_user is not the dependent but is account admin and the account is suspended" do
    before(:each) do
      @current_user             = create_user
      @user_sponsorship         = create_sponsorship(@account, @user, @current_user)
      @current_user_sponsorship = create_sponsorship(@account, @current_user, @current_user)
      @sponsored_project        = create_sponsored_project(@account, @current_user)
      @current_user_membership  = create_membership(@sponsored_project, @current_user, @current_user)
      @sponsorship = create_membership(@sponsored_project, @user, @current_user)
      @sponsorship.current_user_id = @current_user.id #different current user
    end

    describe "where the dependent is invited" do
      before(:each) do
      end
      it "'Status' should return 'Invited'" do
        @sponsorship.should be_invited
        @sponsorship.status.should =~ /invited/i
      end
      it "'Commands' should return nothing" do
        c = @sponsorship.commands    
        c.should be_empty
      end
    end
    describe "where the dependent is uninvited" do
      before(:each) do
        @sponsorship.uninvite
      end
      it "'Status' should return 'Uninvited'" do
        @sponsorship.should be_uninvited
        @sponsorship.status.should =~ /uninvited/i
      end
      it "'Commands' should return nothing" do
        c = @sponsorship.commands    
        c.should be_empty
      end
    end
    describe "where the dependent is enrolled" do
      before(:each) do
        @sponsorship.enroll
      end
      it "'Status' should return 'Enrolled'" do
        @sponsorship.should be_enrolled
        @sponsorship.status.should =~ /enrolled/i
      end
      it "'Commands' should only return 'suspend'" do
        c = @sponsorship.commands    
        c.should be_empty
      end
    end
    describe "where the dependent is suspended" do
      before(:each) do
        @sponsorship.enroll
        @sponsorship.suspend
      end
      it "'Status' should return 'Suspended'" do
        @sponsorship.should be_suspended
        @sponsorship.status.should =~ /suspended/i
      end
      it "'Commands' should only return 'suspend'" do
        c = @sponsorship.commands    
        c.should be_empty
      end
    end
    describe "where the dependent is withdrawn" do
      before(:each) do
        @sponsorship.enroll
        @sponsorship.withdraw
      end
      it "'Status' should return 'Withdrawn'" do
        @sponsorship.should be_withdrawn
        @sponsorship.status.should =~ /withdrawn/i
      end
      it "'Commands' should only return 'suspend'" do
        c = @sponsorship.commands    
        c.should be_empty
      end
    end
    describe "where the dependent is removed" do
      before(:each) do
        @sponsorship.enroll
        @sponsorship.suspend
        @sponsorship.remove
      end
      it "'Status' should return 'Removed'" do
        @sponsorship.should be_removed
        @sponsorship.status.should =~ /removed/i
      end
      it "'Commands' should only return 'nothing'" do
        c = @sponsorship.commands    
        c.should be_empty
      end
    end
  end
end

def create_user
  Factory(:user)
end

def create_account (current_user)
  Factory(:account, :created_by => current_user.id)
end

def create_sponsorship(account, user, current_user)
  Factory(:sponsorship,
  :user_id    => user.id,
  :account_id => account.id,
  :created_by => current_user.id)
end

def create_sponsored_project(account, current_user)
  Factory(:project, 
  :account_id => account.id, 
  :created_by => current_user.id)
end

def create_membership(project, user, current_user)  
  Factory(:membership, 
  :user_id    => user.id, 
  :project_id => project.id,
  :created_by => current_user.id)
end

def promote_to_admin(membership)
  membership.promote_access if membership.access_observer?
  membership.promote_access if membership.access_contributor?
end


require 'spec_helper'
require 'spec_models_helper'

describe "Membership status and commands" do
  before(:each) do
    @user = create_user
    @account = create_account(@user)
  end

  describe "when current_user is the member and" do
    before(:each) do
      @current_user = @user
      @sponsorship = create_sponsorship(@account, @user, @current_user)
      @sponsored_project = create_sponsored_project(@account, @current_user)
      @membership = create_membership(@sponsored_project, @user, @current_user)
      @membership.current_user_id = @current_user.id
    end
  
    describe "where the member is invited" do
      before(:each) do
        #nothing
      end
      it "'Status' should return 'Invited'" do
        @membership.should be_invited
        @membership.status.should =~ /invited/i
      end
      it "'commands' should return 'enroll'" do
        c = @membership.commands
        c.should have(1).item
        c.first[:command].should =~ /enroll/
      end
    end
    describe "where the member is uninvited" do
      before(:each) do
        @membership.uninvite
      end
      it "'Status' should return 'Uninvited'" do
        @membership.should be_uninvited
        @membership.status.should =~ /uninvited/i
      end
      it "'commands' should return nothing" do
        c = @membership.commands
        c.should be_empty
      end
    end
    describe "where the member is enrolled" do
      before(:each) do
        @membership.enroll
      end
      it "'Status' should return 'Invited'" do
        @membership.should be_enrolled
        @membership.status.should =~ /enrolled/i
      end
      it "'commands' should return 'enroll'" do
        c = @membership.commands
        c.should have(1).item
        c.first[:command].should =~ /withdraw/
      end
    end
    describe "where the member is suspended" do
      before(:each) do
        @membership.enroll
        @membership.suspend
      end
      it "'Status' should return 'Enrolled'" do
        @membership.should be_suspended
        @membership.status.should =~ /suspended/i
      end
      it "'commands' should return nothing" do
        c = @membership.commands
        c.should be_empty
      end
    end
    describe "where the member is withdrawn" do
      before(:each) do
        @membership.enroll
        @membership.withdraw
      end
      it "'Status' should return 'Withdrawn'" do
        @membership.should be_withdrawn
        @membership.status.should =~ /withdrawn/i
      end
      it "'commands' should return 'rejoin'" do
        c = @membership.commands
        c.should have(1).item
        c.first[:command].should =~ /rejoin/
      end
    end
    describe "where the member is removed" do
      before(:each) do
        @membership.enroll
        @membership.withdraw
        @membership.remove
      end
      it "'Status' should return 'Removed'" do
        @membership.should be_removed
        @membership.status.should =~ /removed/i
      end
      it "'commands' should return nothing" do
        c = @membership.commands
        c.should be_empty
      end
    end
  end
  
  describe "when current_user is the member and project is suspended and" do
    before(:each) do
      @current_user = @user
      @sponsorship = create_sponsorship(@account, @user, @current_user)
      @sponsored_project = create_sponsored_project(@account, @current_user)
      @sponsored_project.suspend #suspend
      @membership = create_membership(@sponsored_project, @user, @current_user)
      @membership.current_user_id = @current_user.id
    end
  
    describe "where the member is invited" do
      before(:each) do
        #nothing
      end
      it "'Status' should return 'suspended'" do
        @membership.should be_invited
        @membership.status.should =~ /Project Suspended/i
      end
      it "'commands' should return nothing" do
        c = @membership.commands
        c.should be_empty
      end
    end
    describe "where the member is uninvited" do
      before(:each) do
        @membership.uninvite
      end
      it "'Status' should return 'suspended'" do
        @membership.should be_uninvited
        @membership.status.should =~ /suspended/i
      end
      it "'commands' should return nothing" do
        c = @membership.commands
        c.should be_empty
      end
    end
    describe "where the member is enrolled" do
      before(:each) do
        @membership.enroll
      end
      it "'Status' should return 'suspended'" do
        @membership.should be_enrolled
        @membership.status.should =~ /suspended/i
      end
      it "'commands' should return nothing" do
        c = @membership.commands
        c.should be_empty
      end
    end
    describe "where the member is suspended" do
      before(:each) do
        @membership.enroll
        @membership.suspend
      end
      it "'Status' should return 'suspended'" do
        @membership.should be_suspended
        @membership.status.should =~ /suspended/i
      end
      it "'commands' should return nothing" do
        c = @membership.commands
        c.should be_empty
      end
    end
    describe "where the member is withdrawn" do
      before(:each) do
        @membership.enroll
        @membership.withdraw
      end
      it "'Status' should return 'suspended'" do
        @membership.should be_withdrawn
        @membership.status.should =~ /suspended/i
      end
      it "'commands' should return nothing" do
        c = @membership.commands
        c.should be_empty
      end
    end
    describe "where the member is removed" do
      before(:each) do
        @membership.enroll
        @membership.withdraw
        @membership.remove
      end
      it "'Status' should return 'suspended'" do
        @membership.should be_removed
        @membership.status.should =~ /suspended/i
      end
      it "'commands' should return nothing" do
        c = @membership.commands
        c.should be_empty
      end
    end
  end
  
  describe "when current_user is the member and a project admin and" do
    before(:each) do
      @current_user = @user
      @sponsorship = create_sponsorship(@account, @user, @current_user)
      @sponsored_project = create_sponsored_project(@account, @current_user)
      @membership = create_membership(@sponsored_project, @user, @current_user)
      promote_to_admin(@membership)
      @membership.current_user_id = @current_user.id
    end
    
    describe "where the member is invited" do
      before(:each) do
        #nothing
      end
      it "'Status' should return 'Invited'" do
        @membership.should be_invited
        @membership.status.should =~ /invited/i
      end
      it "'commands' should return 'enroll'" do
        c = @membership.commands
        c.should have(1).items
        c[0][:command].should =~ /enroll/
      end
    end
    describe "where the member is uninvited" do
      before(:each) do
        @membership.uninvite
      end
      it "'Status' should return 'Uninvited'" do
        @membership.should be_uninvited
        @membership.status.should =~ /uninvited/i
      end
      it "'commands' should return nothing" do
        c = @membership.commands
        c.should have(1).items
        c[0][:command].should =~ /invite/
      end
    end
    describe "where the member is enrolled" do
      before(:each) do
        @membership.enroll
      end
      it "'Status' should return 'Invited'" do
        @membership.should be_enrolled
        @membership.status.should =~ /enrolled/i
      end
      it "'commands' should return 'enroll'" do
        c = @membership.commands
        c.should have(1).item
        c.first[:command].should =~ /withdraw/
      end
    end
    describe "where the member is suspended" do
      before(:each) do
        @membership.enroll
        @membership.suspend
      end
      it "'Status' should return 'Enrolled'" do
        @membership.should be_suspended
        @membership.status.should =~ /suspended/i
      end
      it "'commands' should return nothing" do
        c = @membership.commands
        c.should have(1).item
        c.first[:command].should =~ /reinstate/
      end
    end
    describe "where the member is withdrawn" do
      before(:each) do
        @membership.enroll
        @membership.withdraw
      end
      it "'Status' should return 'Withdrawn'" do
        @membership.should be_withdrawn
        @membership.status.should =~ /withdrawn/i
      end
      it "'commands' should return 'rejoin'" do
        c = @membership.commands
        c.should have(1).item
        c.first[:command].should =~ /rejoin/
      end
    end
    describe "where the member is removed" do
      before(:each) do
        @membership.enroll
        @membership.withdraw
        @membership.remove
      end
      it "'Status' should return 'Removed'" do
        @membership.should be_removed
        @membership.status.should =~ /removed/i
      end
      it "'commands' should return nothing" do
        c = @membership.commands
        c.should be_empty
      end
    end
  end

  describe "when current_user is the member and a account admin and" do
    before(:each) do
      @current_user = @user
      @sponsorship = create_sponsorship(@account, @user, @current_user)
      @sponsorship.promote_access #make accont admin
      @sponsored_project = create_sponsored_project(@account, @current_user)
      @membership = create_membership(@sponsored_project, @user, @current_user)
      @membership.current_user_id = @current_user.id
    end

    describe "where the member is invited" do
      before(:each) do
        #nothing
      end
      it "'Status' should return 'Invited'" do
        @membership.should be_invited
        @membership.status.should =~ /invited/i
      end
      it "'commands' should return 'enroll' and 'suspend'" do
        c = @membership.commands
        c.should have(2).items
        c[0][:command].should =~ /enroll/
        c[1][:command].should =~ /suspend/
      end
    end
    describe "where the member is uninvited" do
      before(:each) do
        @membership.uninvite
      end
      it "'Status' should return 'Uninvited'" do
        @membership.should be_uninvited
        @membership.status.should =~ /uninvited/i
      end
      it "'commands' should return 'suspend'" do
        c = @membership.commands
        c.should have(1).items
        c[0][:command].should =~ /suspend/
      end
    end
    describe "where the member is enrolled" do
      before(:each) do
        @membership.enroll
      end
      it "'Status' should return 'Enrolled'" do
        @membership.should be_enrolled
        @membership.status.should =~ /enrolled/i
      end
      it "'commands' should return 'withdraw' and 'suspend'" do
        c = @membership.commands
        c.should have(2).item
        c[0][:command].should =~ /withdraw/
        c[1][:command].should =~ /suspend/
      end
    end
    describe "where the member is suspended" do
      before(:each) do
        @membership.enroll
        @membership.suspend
      end
      it "'Status' should return 'Suspended'" do
        @membership.should be_suspended
        @membership.status.should =~ /suspended/i
      end
      it "'commands' should return 'suspend'" do
        c = @membership.commands
        c.should have(1).item
        c.first[:command].should =~ /suspend/ #suspend project
      end
    end
    describe "where the member is withdrawn" do
      before(:each) do
        @membership.enroll
        @membership.withdraw
      end
      it "'Status' should return 'Withdrawn'" do
        @membership.should be_withdrawn
        @membership.status.should =~ /withdrawn/i
      end
      it "'commands' should return 'rejoin' and 'suspend'" do
        c = @membership.commands
        c.should have(2).items
        c[0][:command].should =~ /rejoin/
        c[1][:command].should =~ /suspend/
      end
    end
    describe "where the member is removed" do
      before(:each) do
        @membership.enroll
        @membership.withdraw
        @membership.remove
      end
      it "'Status' should return 'Removed'" do
        @membership.should be_removed
        @membership.status.should =~ /removed/i
      end
      it "'commands' should return nothing" do
        c = @membership.commands
        c.should be_empty
      end
    end
  end
  
  describe "when current_user is the member and a project admin and a account admin and" do
    before(:each) do
      @current_user = @user
      @sponsorship = create_sponsorship(@account, @user, @current_user)
      @sponsorship.promote_access #make account admin
      @sponsored_project = create_sponsored_project(@account, @current_user)
      @membership = create_membership(@sponsored_project, @user, @current_user)
      promote_to_admin(@membership) #make project admin
      @membership.current_user_id = @current_user.id
    end
    
    describe "where the member is invited" do
      before(:each) do
        #nothing
      end
      it "'Status' should return 'Invited'" do
        @membership.should be_invited
        @membership.status.should =~ /invited/i
      end
      it "'commands' should return 'enroll' and 'suspend'" do
        c = @membership.commands
        c.should have(2).items
        c[0][:command].should =~ /enroll/
        c[1][:command].should =~ /suspend/  #suspend project
      end
    end
    describe "where the member is uninvited" do
      before(:each) do
        @membership.uninvite
      end
      it "'Status' should return 'Uninvited'" do
        @membership.should be_uninvited
        @membership.status.should =~ /uninvited/i
      end
      it "'commands' should return 'suspend'" do
        c = @membership.commands
        c.should have(2).items
        c[0][:command].should =~ /invite/
        c[1][:command].should =~ /suspend/
      end
    end
    describe "where the member is enrolled" do
      before(:each) do
        @membership.enroll
      end
      it "'Status' should return 'Enrolled'" do
        @membership.should be_enrolled
        @membership.status.should =~ /enrolled/i
      end
      it "'commands' should return 'withdraw' and 'suspend'" do
        c = @membership.commands
        c.should have(2).item
        c[0][:command].should =~ /withdraw/
        c[1][:command].should =~ /suspend/
      end
    end
    describe "where the member is suspended" do
      before(:each) do
        @membership.enroll
        @membership.suspend
      end
      it "'Status' should return 'Suspended'" do
        @membership.should be_suspended
        @membership.status.should =~ /suspended/i
      end
      it "'commands' should return nothing" do
        c = @membership.commands
        c.should have(2).item
        c[0][:command].should =~ /reinstate/ #membership
        c[1][:command].should =~ /suspend/ #suspend project
      end
    end
    describe "where the member is withdrawn" do
      before(:each) do
        @membership.enroll
        @membership.withdraw
      end
      it "'Status' should return 'Withdrawn'" do
        @membership.should be_withdrawn
        @membership.status.should =~ /withdrawn/i
      end
      it "'commands' should return 'rejoin' and 'suspend'" do
        c = @membership.commands
        c.should have(2).items
        c[0][:command].should =~ /rejoin/
        c[1][:command].should =~ /suspend/
      end
    end
    describe "where the member is removed" do
      before(:each) do
        @membership.enroll
        @membership.withdraw
        @membership.remove
      end
      it "'Status' should return 'Removed'" do
        @membership.should be_removed
        @membership.status.should =~ /removed/i
      end
      it "'commands' should return nothing" do
        c = @membership.commands
        c.should be_empty
      end
    end
  end
  
  describe "when current_user is not the member but is a project admin and" do
    before(:each) do
      @current_user             = create_user
      @user_sponsorship         = create_sponsorship(@account, @user, @current_user)
      @current_user_sponsorship = create_sponsorship(@account, @current_user, @current_user)
      @sponsored_project        = create_sponsored_project(@account, @current_user)
      @current_user_membership = create_membership(@sponsored_project, @current_user, @current_user)
      promote_to_admin(@current_user_membership)
      @membership = create_membership(@sponsored_project, @user, @current_user)
      @membership.current_user_id = @current_user.id #different current user
    end
  
    describe "where the member is invited" do
      before(:each) do
        #nothing
      end
      it "'Status' should return 'Invited'" do
        @membership.should be_invited
        @membership.status.should =~ /invited/i
      end
      it "'Commands' should return 'uninvite'" do
        c = @membership.commands      
        c.should have(1).item
        c.first[:command].should =~ /uninvite/
      end
    end
    describe "where the member is uninvited" do
      before(:each) do
        @membership.uninvite
      end
      it "'Status' should return 'Invited'" do
        @membership.should be_uninvited
        @membership.status.should =~ /uninvited/i
      end
      it "'Commands' should return 'invite'" do
        c = @membership.commands      
        c.should have(1).item
        c.first[:command].should =~ /invite/
      end
    end
    describe "where the member is enrolled" do
      before(:each) do
        @membership.enroll
      end
      it "'Status' should return 'Enrolled'" do
        @membership.should be_enrolled
        @membership.status.should =~ /enrolled/i
      end
      it "'Commands' should return 'suspend'" do
        c = @membership.commands      
        c.should have(1).item
        c.first[:command].should =~ /suspend/
      end
    end
    describe "where the member is suspended" do
      before(:each) do
        @membership.enroll
        @membership.suspend
      end
      it "'Status' should return 'Suspended'" do
        @membership.should be_suspended
        @membership.status.should =~ /suspended/i
      end
      it "'Commands' should return 'reinstate'" do
        c = @membership.commands      
        c.should have(1).item
        c.first[:command].should =~ /reinstate/
      end
    end
    describe "where the member is withdrawn" do
      before(:each) do
        @membership.enroll
        @membership.withdraw
      end
      it "'Status' should return 'Withdrawn'" do
        @membership.should be_withdrawn
        @membership.status.should =~ /withdrawn/i
      end
      it "'Commands' should return 'suspend'" do
        c = @membership.commands      
        c.should have(1).item
        c.first[:command].should =~ /suspend/
      end
    end
    describe "where the member is removed" do
      before(:each) do
        @membership.enroll
        @membership.suspend
        @membership.remove
      end
      it "'Status' should return 'Removed'" do
        @membership.should be_removed
        @membership.status.should =~ /removed/i
      end
      it "'Commands' should return nothing" do
        c = @membership.commands      
        c.should be_empty
      end
    end
  end

  describe "when current_user is not the member but is account admin and" do
    before(:each) do
      @current_user             = create_user
      @user_sponsorship         = create_sponsorship(@account, @user, @current_user)
      @current_user_sponsorship = create_sponsorship(@account, @current_user, @current_user)
      @current_user_sponsorship.promote_access #account admin
      @sponsored_project        = create_sponsored_project(@account, @current_user)
      @current_user_membership = create_membership(@sponsored_project, @current_user, @current_user)
      @membership = create_membership(@sponsored_project, @user, @current_user)
      @membership.current_user_id = @current_user.id #different current user
    end
    
    describe "where the member is invited" do
      before(:each) do
      end
      it "'Status' should return 'Invited'" do
        @membership.should be_invited
        @membership.status.should =~ /invited/i
      end
      it "'Commands' should only return 'suspend'" do
        c = @membership.commands    
        c.should have(1).items
        c[0][:command].should =~ /suspend/ #suspend project
      end
    end
    describe "where the member is uninvited" do
      before(:each) do
        @membership.uninvite
      end
      it "'Status' should return 'Uninvited'" do
        @membership.should be_uninvited
        @membership.status.should =~ /uninvited/i
      end
      it "'Commands' should only return 'suspend'" do
        c = @membership.commands    
        c.should have(1).items
        c[0][:command].should =~ /suspend/ #suspend project
      end
    end
    describe "where the member is enrolled" do
      before(:each) do
        @membership.enroll
      end
      it "'Status' should return 'Enrolled'" do
        @membership.should be_enrolled
        @membership.status.should =~ /enrolled/i
      end
      it "'Commands' should only return 'suspend'" do
        c = @membership.commands    
        c.should have(1).items
        c[0][:command].should =~ /suspend/ #suspend project
      end
    end
    describe "where the member is suspended" do
      before(:each) do
        @membership.enroll
        @membership.suspend
      end
      it "'Status' should return 'Suspended'" do
        @membership.should be_suspended
        @membership.status.should =~ /suspended/i
      end
      it "'Commands' should only return 'suspend'" do
        c = @membership.commands    
        c.should have(1).items
        c[0][:command].should =~ /suspend/ #suspend project
      end
    end
    describe "where the member is withdrawn" do
      before(:each) do
        @membership.enroll
        @membership.withdraw
      end
      it "'Status' should return 'Withdrawn'" do
        @membership.should be_withdrawn
        @membership.status.should =~ /withdrawn/i
      end
      it "'Commands' should only return 'suspend'" do
        c = @membership.commands    
        c.should have(1).items
        c[0][:command].should =~ /suspend/ #suspend project
      end
    end
    describe "where the member is removed" do
      before(:each) do
        @membership.enroll
        @membership.suspend
        @membership.remove
      end
      it "'Status' should return 'Removed'" do
        @membership.should be_removed
        @membership.status.should =~ /removed/i
      end
      it "'Commands' should only return 'nothing'" do
        c = @membership.commands    
        c.should be_empty
      end
    end
  end

  describe "when current_user is not the member but is invited to the project" do
    before(:each) do
      @current_user             = create_user
      @user_sponsorship         = create_sponsorship(@account, @user, @current_user)
      @current_user_sponsorship = create_sponsorship(@account, @current_user, @current_user)
      @sponsored_project        = create_sponsored_project(@account, @current_user)
      @current_user_membership  = create_membership(@sponsored_project, @current_user, @current_user)
      @membership = create_membership(@sponsored_project, @user, @current_user)
      @membership.current_user_id = @current_user.id #different current user
    end
    
    describe "where the member is invited" do
      before(:each) do
      end
      it "'Status' should return 'Invited'" do
        @membership.should be_invited
        @membership.status.should =~ /invited/i
      end
      it "'Commands' should return nothing" do
        c = @membership.commands    
        c.should be_empty
      end
    end
    describe "where the member is uninvited" do
      before(:each) do
        @membership.uninvite
      end
      it "'Status' should return 'Uninvited'" do
        @membership.should be_uninvited
        @membership.status.should =~ /uninvited/i
      end
      it "'Commands' should return nothing" do
        c = @membership.commands    
        c.should be_empty
      end
    end
    describe "where the member is enrolled" do
      before(:each) do
        @membership.enroll
      end
      it "'Status' should return 'Enrolled'" do
        @membership.should be_enrolled
        @membership.status.should =~ /enrolled/i
      end
      it "'Commands' should only return 'suspend'" do
        c = @membership.commands    
        c.should be_empty
      end
    end
    describe "where the member is suspended" do
      before(:each) do
        @membership.enroll
        @membership.suspend
      end
      it "'Status' should return 'Suspended'" do
        @membership.should be_suspended
        @membership.status.should =~ /suspended/i
      end
      it "'Commands' should only return 'suspend'" do
        c = @membership.commands    
        c.should be_empty
      end
    end
    describe "where the member is withdrawn" do
      before(:each) do
        @membership.enroll
        @membership.withdraw
      end
      it "'Status' should return 'Withdrawn'" do
        @membership.should be_withdrawn
        @membership.status.should =~ /withdrawn/i
      end
      it "'Commands' should only return 'suspend'" do
        c = @membership.commands    
        c.should be_empty
      end
    end
    describe "where the member is removed" do
      before(:each) do
        @membership.enroll
        @membership.suspend
        @membership.remove
      end
      it "'Status' should return 'Removed'" do
        @membership.should be_removed
        @membership.status.should =~ /removed/i
      end
      it "'Commands' should only return 'nothing'" do
        c = @membership.commands    
        c.should be_empty
      end
    end
  end
end

    

require 'spec_helper'
require 'spec_models_helper'

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
      @account.suspend
    end

    describe "where the dependent is invited" do
      before(:each) do
        #nothing
      end
      it "'Status' should return 'suspended'" do
        @sponsorship.should be_invited
        @sponsorship.status.should =~ /Account Suspended/i
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
        @sponsorship.status.should =~ /Account Suspended/i
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
        @sponsorship.status.should =~ /Account Suspended/i
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
        @sponsorship.status.should =~ /Account Suspended/i
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
        @sponsorship.status.should =~ /Account Suspended/i
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
        @sponsorship.status.should =~ /Account Suspended/i
      end
      it "'commands' should return nothing" do
        c = @sponsorship.commands
        c.should be_empty
      end
    end
  end

  describe "when current_user is the dependent and both account admin and sys admin; and" do
    before(:each) do
      @current_user = @user
      @sponsorship  = create_sponsorship(@account, @user, @current_user)
      @current_user.promote
      @sponsorship.promote_access
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
        c[1][:command].should =~ /suspend/ #suspend account
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
      it "'commands' should return 'invite' and 'suspend'" do
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
      it "'commands' should return 'suspend' (sponsorship) and 'suspend' (account)" do
        c = @sponsorship.commands
        c.should have(2).item
        c[0][:command].should =~ /reinstate/ #reinstate sponsorship
        c[1][:command].should =~ /suspend/ #suspend account
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

  describe "when current_user is the dependent and both account admin and sys admin; and account is suspended and" do
    before(:each) do
      @current_user = @user
      @sponsorship = create_sponsorship(@account, @user, @current_user)
      @sponsorship.promote_access #make account admin
      @sponsorship.current_user_id = @current_user.id
      @current_user.promote #to sys_admin
      @account.suspend
    end

    describe "where the dependent is invited" do
      before(:each) do
        #nothing
      end
      it "'Status' should return 'Account Suspended'" do
        @sponsorship.should be_invited
        @sponsorship.status.should =~ /Account Suspended/i
      end
      it "'commands' should return 'reinstate'" do
        c = @sponsorship.commands
        c.should have(1).item
        c[0][:command].should =~ /reinstate/  #reinstate account
      end
    end
    describe "where the dependent is uninvited" do
      before(:each) do
        @sponsorship.uninvite
      end
      it "'Status' should return 'Account Suspended'" do
        @sponsorship.should be_uninvited
        @sponsorship.status.should =~ /Account Suspended/i
      end
      it "'commands' should return 'reinstate'" do
        c = @sponsorship.commands
        c.should have(1).item
        c[0][:command].should =~ /reinstate/  #reinstate account
      end
    end
    describe "where the dependent is enrolled" do
      before(:each) do
        @sponsorship.enroll
      end
      it "'Status' should return 'Account Suspended'" do
        @sponsorship.should be_enrolled
        @sponsorship.status.should =~ /Account Suspended/i
      end
      it "'commands' should return 'reinstate'" do
        c = @sponsorship.commands
        c.should have(1).item
        c[0][:command].should =~ /reinstate/  #reinstate account
      end
    end
    describe "where the dependent is suspended" do
      before(:each) do
        @sponsorship.enroll
        @sponsorship.suspend
      end
      it "'Status' should return 'Account Suspended'" do
        @sponsorship.should be_suspended
        @sponsorship.status.should =~ /Account Suspended/i
      end
      it "'commands' should return 'reinstate'" do
        c = @sponsorship.commands
        c.should have(1).item
        c[0][:command].should =~ /reinstate/  #reinstate account
      end
    end
    describe "where the dependent is withdrawn" do
      before(:each) do
        @sponsorship.enroll
        @sponsorship.withdraw
      end
      it "'Status' should return 'Account Suspended'" do
        @sponsorship.should be_withdrawn
        @sponsorship.status.should =~ /Account Suspended/i
      end
      it "'commands' should return 'reinstate'" do
        c = @sponsorship.commands
        c.should have(1).item
        c[0][:command].should =~ /reinstate/  #reinstate account
      end
    end
    describe "where the dependent is removed" do
      before(:each) do
        @sponsorship.enroll
        @sponsorship.withdraw
        @sponsorship.remove
      end
      it "'Status' should return 'Acccount Suspended'" do
        @sponsorship.should be_removed
        @sponsorship.status.should =~ /Account Suspended/i
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
      @sponsorship              = create_sponsorship(@account, @user, @current_user)
      @current_user_sponsorship = create_sponsorship(@account, @current_user, @current_user)
    end

    describe "where the dependent is invited" do
      before(:each) do
        #nothing
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
      it "'Status' should return 'Invited'" do
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
      it "'Commands' should return nothing" do
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
      it "'Commands' should return nothing" do
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
      it "'Commands' should return nothing" do
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
      it "'Commands' should return nothing" do
        c = @sponsorship.commands      
        c.should be_empty
      end
    end
  end

  describe "when current_user is not the dependent but is account admin and" do
    before(:each) do
      @current_user             = create_user
      @sponsorship              = create_sponsorship(@account, @user, @current_user)
      @current_user_sponsorship = create_sponsorship(@account, @current_user, @current_user)
      @current_user_sponsorship.promote_access #make admin
    end

    describe "where the dependent is invited" do
      before(:each) do
        #nothing
      end
      it "'Status' should return 'Invited'" do
        @sponsorship.should be_invited
        @sponsorship.status.should =~ /invited/i
      end
      it "'Commands' should return 'invite'" do
        c = @sponsorship.commands      
        c.should have(1).item
        c[0][:command].should =~ /uninvite/
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
        c[0][:command].should =~ /invite/
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
        c[0][:command].should =~ /suspend/ #sponsorship
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
        c[0][:command].should =~ /reinstate/
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
        c[0][:command].should =~ /suspend/
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

  describe "when current_user is not the dependent but is sys admin and" do
    before(:each) do
      @current_user             = create_user
      @current_user.promote
      @sponsorship              = create_sponsorship(@account, @user, @current_user)
      @current_user_sponsorship = create_sponsorship(@account, @current_user, @current_user)
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
        c.should have(1).item
        c[0][:command].should =~ /suspend/ #suspend account
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
        c.should have(1).item
        c[0][:command].should =~ /suspend/ #suspend account
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
        c.should have(1).item
        c[0][:command].should =~ /suspend/ #suspend account
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
        c[0][:command].should =~ /suspend/ #suspend account
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
        c[0][:command].should =~ /suspend/ #suspend account
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

  describe "when current_user is not the dependent but is sys admin and the account is suspended and" do
    before(:each) do
      @current_user = create_user
      @current_user.promote
      @sponsorship  = create_sponsorship(@account, @user, @current_user)
      @current_user_sponsorship = create_sponsorship(@account, @current_user, @current_user)
      @account.suspend
    end

    describe "where the dependent is invited" do
      before(:each) do
      end
      it "'Status' should return 'Invited'" do
        @sponsorship.should be_invited
        @sponsorship.status.should =~ /Account Suspended/i
      end
      it "'Commands' should return 'reinstate'" do
        c = @sponsorship.commands    
        c.should have(1).item
        c[0][:command].should =~ /reinstate/  #reinstate account
      end
    end
    describe "where the dependent is uninvited" do
      before(:each) do
        @sponsorship.uninvite
      end
      it "'Status' should return 'Uninvited'" do
        @sponsorship.should be_uninvited
        @sponsorship.status.should =~ /Account Suspended/i
      end
      it "'Commands' should return 'reinstate'" do
        c = @sponsorship.commands    
        c.should have(1).item
        c[0][:command].should =~ /reinstate/  #reinstate account
      end
    end
    describe "where the dependent is enrolled" do
      before(:each) do
        @sponsorship.enroll
      end
      it "'Status' should return 'Enrolled'" do
        @sponsorship.should be_enrolled
        @sponsorship.status.should =~ /Account Suspended/i
      end
      it "'Commands' should only return 'reinstate'" do
        c = @sponsorship.commands    
        c.should have(1).item
        c[0][:command].should =~ /reinstate/  #reinstate account
      end
    end
    describe "where the dependent is suspended" do
      before(:each) do
        @sponsorship.enroll
        @sponsorship.suspend
      end
      it "'Status' should return 'reinstate'" do
        @sponsorship.should be_suspended
        @sponsorship.status.should =~ /Account Suspended/i
      end
      it "'Commands' should only return 'suspend'" do
        c = @sponsorship.commands    
        c.should have(1).item
        c[0][:command].should =~ /reinstate/  #reinstate account
      end
    end
    describe "where the dependent is withdrawn" do
      before(:each) do
        @sponsorship.enroll
        @sponsorship.withdraw
      end
      it "'Status' should return 'Withdrawn'" do
        @sponsorship.should be_withdrawn
        @sponsorship.status.should =~ /Account Suspended/i
      end
      it "'Commands' should only return 'reinstate'" do
        c = @sponsorship.commands    
        c.should have(1).item
        c[0][:command].should =~ /reinstate/  #reinstate account
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
        @sponsorship.status.should =~ /Account Suspended/i
      end
      it "'Commands' should only return 'nothing'" do
        c = @sponsorship.commands    
        c.should be_empty
      end
    end
  end
end



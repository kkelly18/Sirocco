require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the AccountsHelper. For example:
#
# describe AccountsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
require 'spec_helper'

describe AccountsHelper do
  describe "#sponsorship" do
    it "should respond." do
      helper.should respond_to(:sponsorship_status)
    end

    it "should guard the parameter." do
      pending
    end

    describe "returns a users status for an account." do      

      describe "In ACTIVE accounts" do
        describe "where the user is NOT AN ACCOUNT ADMIN" do
          before(:each) do      
            setup_account_and_user_and_active_account
            #each example will hookup different associaions for different tests
          end
          describe "and where they are INVITED," do
            it "'status' should return 'Invited'." do
              assoc = associate(@user.id, @account.id)
              sponsorship_status(assoc).should =~ /Invited/
            end
          end
          describe "and where they are ENROLLED," do
            it "'status' should return 'Enrolled'." do
              assoc = associate(@user.id, @account.id)
              assoc.enroll
              sponsorship_status(assoc).should =~ /Enrolled/
            end
          end
        end
        describe "where the user is an ACCOUNT ADMIN" do
          before(:each) do      
            setup_account_and_admin_and_active_account
          end
          describe "and where they are INVITED," do
            it "'status' should return 'Invited'." do
              assoc = associate(@admin.id, @account.id)
              sponsorship_status(assoc).should =~ /Invited/
            end
          end
          describe "and where they are ENROLLED," do
            it "'status' should return 'Enrolled'." do
              assoc = associate(@admin.id, @account.id)
              assoc.enroll
              sponsorship_status(assoc).should =~ /Enrolled/
            end
          end
        end        
      end

      describe "In SUSPENDED accounts" do
        describe "where the user is NOT AN ACCOUNT ADMIN" do
          before(:each) do      
            setup_account_and_user_and_suspended_account
          end
          describe "and where they are INVITED," do
            it "'status' should return 'Suspended'." do
              assoc = associate(@user.id, @suspended_account.id)
              sponsorship_status(assoc).should =~ /Suspended/
            end
          end
          describe "and where they are ENROLLED," do
            it "'status' should return 'Suspended'." do
              assoc = associate(@user.id, @suspended_account.id)
              assoc.suspend
              sponsorship_status(assoc).should =~ /Suspended/
            end
          end
        end
        describe "where the user is an ACCOUNT ADMIN" do
          before(:each) do      
            setup_account_and_admin_and_suspended_account
          end
          describe "and where they are INVITED," do
            it "'status' should return 'Suspended'." do
              assoc = associate(@admin.id, @suspended_account.id)
              sponsorship_status(assoc).should =~ /Suspended/
            end
          end
          describe "and where they are ENROLLED," do
            it "'status' should return 'Suspended'." do
              assoc = associate(@admin.id, @suspended_account.id)
              assoc.suspend
              sponsorship_status(assoc).should =~ /Suspended/
            end
          end
        end        
      end
    end
  end

  describe "#sponsorship_commands" do
    it "should respond." do
      helper.should respond_to(:sponsorship_commands)
    end
    
    it "should guard the parameter." do
     pending
    end

    describe "returns available commands matching the users status in a account." do      

      describe "In ACTIVE accounts" do
        describe "where the user is NOT AN ACCOUNT ADMIN" do
          before(:each) do
            setup_account_and_user_and_active_account
            # @user = Factory(:user)
            # @account = Factory(:account)      
            #setup_account_and_user_and_active_account #todo rename method
            #each example will hookup different associaions for different tests
          end
          describe "and where they are INVITED," do
            it "'commands' should return 'Enroll'." do
              assoc = associate(@user.id, @account.id)

              c = sponsorship_commands(assoc)
              #example c == [{:command => 'command', :text => 'text'}]
              c.should have(1).item
              c.first[:command].should =~ /enroll/
            end
          end
          describe "and where they are ENROLLED," do
            it "'commands' should return 'Withdraw'." do
              assoc = associate(@user.id, @account.id)
              assoc.enroll

              c = sponsorship_commands(assoc)
              c.should have(1).item
              c.first[:command].should =~ /withdraw/
            end
          end
        end
        describe "where the user is an ACCOUNT ADMIN" do
          before(:each) do      
            @user = Factory(:user)
            @account = Factory(:account)      
            #setup_account_and_user_and_active_account #todo rename method and promote
          end
          describe "and where they are INVITED," do
            it "'commands' should return 'Enroll'." do
              assoc = associate(@user.id, @account.id)
              assoc.promote_access

              c = sponsorship_commands(assoc)
              c.should have(1).item
              c.first[:command].should =~ /enroll/
            end
          end
          describe "and where they are ENROLLED," do
            it "'commands' should return 'Withdraw' and 'Suspend'." do
              assoc = associate(@user.id, @account.id)
              assoc.enroll
              assoc.promote_access
              
              c = sponsorship_commands(assoc)
              c.should have(2).items
              c[0][:command].should =~ /withdraw/
              c[1][:command].should =~ /suspend/
            end
          end
        end        
      end

      describe "In SUSPENDED accounts" do
        describe "where the user is NOT AN ACCOUNT ADMIN" do
          before(:each) do
            @user = Factory(:user)
            @account = Factory(:account)      
            #setup_account_and_user_and_active_account #todo rename method and promote
          end
          describe "and where they are INVITED," do
            it "'commands' should return empty list." do
              assoc = associate(@user.id, @account.id)
              @account.suspend

              c = sponsorship_commands(assoc)
              c.should have(0).items
            end
          end
          
          describe "and where they are ENROLLED," do
            it "'commands' should return empty list." do
              assoc = associate(@user.id, @account.id)
              assoc.enroll
              @account.suspend
              
              c = sponsorship_commands(assoc)
              c.should have(0).items
            end
          end
        end

        describe "where the user is an ACCOUNT ADMIN" do
          before(:each) do      
            @user = Factory(:user)
            @account = Factory(:account)      
            #setup_account_and_user_and_active_account #todo rename method and promote
          end
          describe "and where they are INVITED," do
            it "'commmands' should return 'Reinstate'." do
              assoc = associate(@user.id, @account.id)
              assoc.promote_access
              @account.suspend

              c = sponsorship_commands(assoc)
              c.should have(1).item
              c[0][:command].should =~ /reinstate/
            end
          end
          describe "and where they are ENROLLED," do
            it "'commands' should return 'Reinstate'." do
              assoc = associate(@user.id, @account.id)
              assoc.enroll
              assoc.promote_access
              @account.suspend

              c = sponsorship_commands(assoc)
              c.should have(1).item
              c[0][:command].should =~ /reinstate/
            end
          end
        end        
      end
    end
  end

  def setup_account_and_user_and_active_account
    @account = Factory(:account)
    @user = account_user(@account.id)
  end
  
  def setup_account_and_admin_and_active_account
    @account = Factory(:account)
    @admin = account_user(@account.id, true)
  end
  
  def setup_account_and_user_and_suspended_account
    @account = Factory(:account)
    @user = account_user(@account.id)
    @suspended_account = suspended_account(@account.id)
  end
  
  def setup_account_and_admin_and_suspended_account
    @account = Factory(:account)
    @admin = account_user(@account.id, true)
    @suspended_account = suspended_account(@account.id)
  end

  def associate(user_id, account_id)
    sponsorship = Factory(:sponsorship, 
              :user_id    => user_id, 
              :account_id => account_id)
    return sponsorship
  end
  
  def suspended_account(account_id)
    account = Factory(:account)
    account.suspend
    account.save
    return account        
  end
  
  def account_user(account_id, admin=false)
    user = Factory(:user)     

    account = Factory(:sponsorship,
    :user_id    => user.id,
    :account_id => account_id)
    
    account.promote_access if admin
    account.save
    
    return user
  end  
    
end

require 'spec_helper'

describe ProjectsHelper do
  describe "#membership" do
    it "should respond." do
      helper.should respond_to(:membership_status)
    end

    it "should guard the parameter." do
      pending
    end

    describe "returns a users status for a project." do      

      describe "In ACTIVE projects" do
        describe "where the user is NOT AN ACCOUNT ADMIN" do
          before(:each) do      
            setup_account_and_user_and_active_project
            #each example will hookup different associaions for different tests
          end
          describe "and where they are INVITED," do
            it "'status' should return 'Invited'." do
              assoc = associate(@user.id, @active_project.id)
              membership_status(assoc).should =~ /Invited/
            end
          end
          describe "and where they are ENROLLED," do
            it "'status' should return 'Enrolled'." do
              assoc = associate(@user.id, @active_project.id, Time.now.utc)
              membership_status(assoc).should =~ /Enrolled/
            end
          end
        end
        describe "where the user is an ACCOUNT ADMIN" do
          before(:each) do      
            setup_account_and_admin_and_active_project
          end
          describe "and where they are INVITED," do
            it "'status' should return 'Invited'." do
              assoc = associate(@admin.id, @active_project.id)
              membership_status(assoc).should =~ /Invited/
            end
          end
          describe "and where they are ENROLLED," do
            it "'status' should return 'Enrolled'." do
              assoc = associate(@admin.id, @active_project.id, Time.now.utc)
              membership_status(assoc).should =~ /Enrolled/
            end
          end
        end        
      end

      describe "In SUSPENDED projects" do
        describe "where the user is NOT AN ACCOUNT ADMIN" do
          before(:each) do      
            setup_account_and_user_and_suspended_project
          end
          describe "and where they are INVITED," do
            it "'status' should return 'Suspended'." do
              assoc = associate(@user.id, @suspended_project.id)
              membership_status(assoc).should =~ /Suspended/
            end
          end
          describe "and where they are ENROLLED," do
            it "'status' should return 'Suspended'." do
              assoc = associate(@user.id, @suspended_project.id, Time.now.utc)
              membership_status(assoc).should =~ /Suspended/
            end
          end
        end
        describe "where the user is an ACCOUNT ADMIN" do
          before(:each) do      
            setup_account_and_admin_and_suspended_project
          end
          describe "and where they are INVITED," do
            it "'status' should return 'Suspended'." do
              assoc = associate(@admin.id, @suspended_project.id)
              membership_status(assoc).should =~ /Suspended/
            end
          end
          describe "and where they are ENROLLED," do
            it "'status' should return 'Suspended'." do
              assoc = associate(@admin.id, @suspended_project.id, Time.now.utc)
              membership_status(assoc).should =~ /Suspended/
            end
          end
        end        
      end
    end
  end

  describe "#membership_commands" do
    it "should respond." do
      helper.should respond_to(:membership_commands)
    end
    
    it "should guard the parameter." do
     pending
    end

    describe "returns available commands matching the users status in a project." do      

      describe "In ACTIVE projects" do
        describe "where the user is NOT AN ACCOUNT ADMIN" do
          before(:each) do      
            setup_account_and_user_and_active_project
            #each example will hookup different associaions for different tests
          end
          describe "and where they are INVITED," do
            it "'commands' should return 'Enroll'." do
              assoc = associate(@user.id, @active_project.id)

              c = membership_commands(assoc)
              #example c == [{:command => 'command', :text => 'text'}]
              c.should have(1).item
              c.first[:command].should =~ /enroll/
            end
          end
          describe "and where they are ENROLLED," do
            it "'commands' should return 'Withdraw'." do
              assoc = associate(@user.id, @active_project.id, Time.now.utc)

              c = membership_commands(assoc)
              c.should have(1).item
              c.first[:command].should =~ /withdraw/
            end
          end
        end
        describe "where the user is an ACCOUNT ADMIN" do
          before(:each) do      
            setup_account_and_admin_and_active_project
          end
          describe "and where they are INVITED," do
            it "'commands' should return 'Enroll'." do
              assoc = associate(@admin.id, @active_project.id)

              c = membership_commands(assoc)
              c.should have(1).item
              c.first[:command].should =~ /enroll/
            end
          end
          describe "and where they are ENROLLED," do
            it "'commands' should return 'Withdraw' and 'Suspend'." do
              assoc = associate(@admin.id, @active_project.id, Time.now.utc)

              c = membership_commands(assoc)
              c.should have(2).items
              c[0][:command].should =~ /withdraw/
              c[1][:command].should =~ /suspend/
            end
          end
        end        
      end

      describe "In SUSPENDED projects" do
        describe "where the user is NOT AN ACCOUNT ADMIN" do
          before(:each) do      
            setup_account_and_user_and_suspended_project
          end
          describe "and where they are INVITED," do
            it "'commands' should return empty list." do
              assoc = associate(@user.id, @suspended_project.id)

              c = membership_commands(assoc)
              c.should have(0).items
            end
          end
          
          describe "and where they are ENROLLED," do
            it "'commands' should return empty list." do
              assoc = associate(@user.id, @suspended_project.id, Time.now.utc)

              c = membership_commands(assoc)
              c.should have(0).items
            end
          end
        end

        describe "where the user is an ACCOUNT ADMIN" do
          before(:each) do      
            setup_account_and_admin_and_suspended_project
          end
          describe "and where they are INVITED," do
            it "'commmands' should return 'Reinstate'." do
              assoc = associate(@admin.id, @suspended_project.id)

              c = membership_commands(assoc)
              c.should have(1).item
              c[0][:command].should =~ /reinstate/
            end
          end
          describe "and where they are ENROLLED," do
            it "'commands' should return 'Reinstate'." do
              assoc = associate(@admin.id, @suspended_project.id, Time.now.utc)

              c = membership_commands(assoc)
              c.should have(1).item
              c[0][:command].should =~ /reinstate/
            end
          end
        end        
      end
    end
  end

  def setup_account_and_user_and_active_project
    @account = Factory(:account)
    @user = account_user(@account.id)
    @active_project = active_project(@account.id)
  end
  
  def setup_account_and_admin_and_active_project
    @account = Factory(:account)
    @admin = account_user(@account.id, true)
    @active_project = active_project(@account.id)
  end
  
  def setup_account_and_user_and_suspended_project
    @account = Factory(:account)
    @user = account_user(@account.id)
    @suspended_project = suspended_project(@account.id)
  end
  
  def setup_account_and_admin_and_suspended_project
    @account = Factory(:account)
    @admin = account_user(@account.id, true)
    @suspended_project = suspended_project(@account.id)
  end

  def associate(user_id, project_id, enroll_at=nil)
    Factory(:membership, 
              :user_id    => user_id, 
              :project_id => project_id,
              :enroll_at  => enroll_at)
  end
  
  def active_project(account_id)
    Factory(:project, :account_id => account_id)
  end
  
  def suspended_project(account_id)
    Factory(:project, 
    :account_id => account_id, 
    :suspend_at => Time.now.utc)
  end
  
  def account_user(account_id, admin=false)
    user = Factory(:user)     

    Factory(:sponsorship,
    :user_id    => user.id,
    :account_id => account_id,
    :admin => admin)
    
    return user
  end  
    
end

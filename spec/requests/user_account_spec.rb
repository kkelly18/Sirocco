require 'spec_helper'
#TOOL: save_and_open_page

describe "User#Account" do
  before(:each) do
    @account     = Factory(:account) #use as the personal account
    @user        = Factory(:user)
    @sponsorship = Factory(:sponsorship, :account_id => @account.id, :user_id => @user.id, :created_by => @user.id)
    3.times do
      @project = Factory(:project, :account_id => @account.id, :created_by => @user.id)
      #memberships are created during active record callbacks
    end
    visit root_path               
    click_link   "Sign in"               
      fill_in      "Email",    :with => @user.email
      fill_in      "Password", :with => @user.password  
    click_button "Sign in"
    click_link   "SHOW ACCOUNTS"
  end
  
  it "should navigate a signedin user to an account they are sponsored by" do        
    click_link   "#{@account.name}"
    page.should have_selector('title',:text => "Account")
    page.should have_selector('h1',:text => "#{@account.name}")
    page.should have_selector("a", :href => user_path(@user), :text => "Home")    
    page.should have_selector("a", :href => account_path(@account), :text => "SHOW TEAM")
  end
  it "should navigate back to home from Account show" do
    click_link   "#{@account.name}"
    click_link "Home"
    page.should have_selector('title', :text => "Home")
  end
  it "should show a list of projects sponsored by this account" do
    click_link   "#{@account.name}"
    page.should have_selector("td.index_item", :count=>3)
  end
  it "should not show a project that isn't sponsored by this account" do
    new_account     = Factory(:account) #use as the personal account
    different_sponsorship_same_user = Factory(:sponsorship, :account_id => new_account.id, :user_id => @user.id, :created_by => @user.id)
    new_project_same_user_sponsored_by_new_account = Factory(:project, :account_id => new_account.id, :created_by => @user.id)
    click_link   "#{@account.name}"
    page.should have_selector("td.index_item", :count=>3)
  end
  it "should allow account admin to add (sponsor) another project" do
    click_link   "#{@account.name}"
    page.find_by_id 'project_name'
    fill_in "project_name", :with => 'test_project'
    click_button "Create"
    page.should have_selector("div.flash.success", :text => "test_project")        
    page.should have_selector("td.index_item", :count=>4)
  end
  it "should show user enrolled in new project and the withdraw commmand" do
    click_link   "#{@account.name}"
    page.find_by_id 'project_name'
    fill_in "project_name", :with => 'test_project'
    click_button "Create"
    save_and_open_page
    page.find('td.index_item', :text => 'test_project').find('a', :text => 'Withdraw')
    page.find('td.index_item', :text => 'test_project').click_link('Withdraw')
    save_and_open_page
  end
  it "should allow an account admin to suspend a project" do
    pending
  end
  it "should allow an admin to reinstate a suspended project" do
    pending
  end
  it "should not show create new project dialog to non-admins" do
    pending
  end
  it "should not allow a non-admin to suspend a project" do
    pending
  end
  it "should show a list of users sponsored by this account" do
    pending
  end
  it "should not show a user that isn't in this account" do
    pending
  end
  it "should allow an admin to suspend a user from the account" do
    pending
  end
  it "should not allow a non admin to suspend a user" do
    pending
  end
  it "should allow account admin to add another user" do
    pending
  end
  it "should not show invite user dialog to non-admins" do
    pending
  end      
  it "should navigate a signedin user to an account they are sponsored by, but not an admin for" do
    pending
  end
end
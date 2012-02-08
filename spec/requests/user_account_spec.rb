require 'spec_helper'
require 'spec_models_helper'

#TOOL: save_and_open_page

describe "Accounts#Show" do
  before(:each) do
    @user        = create_user
    @account     = create_account(@user) # a new account, in addition to the personal account
    #creator sponsorships are are built during account creation

    @projects = []
    3.times do
      @projects << create_sponsored_project(@account, @user)
      #creator memberships are built during project creation
    end

    visit root_path               
    click_link   "Sign in"               
    fill_in      "Email",    :with => @user.email
    fill_in      "Password", :with => @user.password  
    click_button "Sign in"
    click_link   "MY ACCOUNTS"
  end

  describe "ACCOUNTS" do
    it "should show two accounts" do
      page.should have_selector("td.index_item", :count=>2)
    end
    it "should navigate signedin user to their personal account" do
      click_link   "Personal Account"
      page.should have_selector('title',:text => "Account")
      page.should have_selector('h1',:text => "Personal Account")
      page.should have_selector("a", :href => user_path(@user), :text => "Home")    
      page.should have_selector("a", :href => account_path(@account), :text => "SHOW TEAM")
    end
    it "should navigate signedin user to a sponsored account" do
      click_link   "#{@account.name}"
      page.should have_selector('title',:text => "Account")
      page.should have_selector('h1',:text => "#{@account.name}")
      page.should have_selector("a", :href => user_path(@user), :text => "Home")    
      page.should have_selector("a", :href => account_path(@account), :text => "SHOW TEAM")
    end
    it "should navigate back to HOME from Accounts#Show" do
      click_link   "#{@account.name}"
      click_link "Home"
      page.should have_selector('title', :text => "Home")
    end
    it "should show a list of projects sponsored by this account" do
      click_link   "#{@account.name}"
      page.should have_selector("td.index_item", :count=>3)
    end
    it "should only show projects sponsored by this account" do
      new_account     = create_account(@user)
      different_sponsorship_same_user = create_sponsorship(new_account, @user, @user)
      new_project_same_user_sponsored_by_new_account = create_sponsored_project(new_account, @user)
      click_link   "#{@account.name}"
      page.should have_selector("td.index_item", :count=>3)
    end
    it "should enable withdraw commmand" do
      click_link   "#{@account.name}"
      item = page.find('td.index_item', :text => "#{@projects[0].name}")
      item.click_link('Withdraw')
      item = page.find('td.index_item', :text => "#{@projects[0].name}")
      item.find('a', :text => 'Rejoin')
    end

    describe "where current user is not account admin" do
      before (:each) do
        @sponsorship = User.find(@user.id).sponsorships.where(:account_id => @account.id).first
        @sponsorship.current_user_id = @user.id
        @sponsorship.demote_access
        click_link  "#{@account.name}"    
      end

      it "should not show create new project dialog" do
        page.should_not have_field('project_name')
      end
      it "should not show suspend command on items" do
        item = page.find('td.index_item', :text => "#{@projects[0].name}")
        item.should_not have_link('Suspend')
      end
    end

    describe "where current user is account admin" do
      before (:each) do
        click_link  "#{@account.name}"    
      end
      
      it "should show create new project dialog" do
        page.should have_field('project_name')
      end
      it "should add another project" do
        page.find_by_id 'project_name'
        fill_in "project_name", :with => 'test_project'
        click_button "Create"
        page.should have_selector("div.flash.success", :text => "test_project")        
        page.should have_selector("td.index_item", :count=>4)
      end
      it "should enable suspend command" do
        item = page.find('td.index_item', :text => "#{@projects[0].name}")
        item.click_link('Suspend')
        item = page.find('td.index_item', :text => "#{@projects[0].name}")
        item.should have_link('Reinstate')
      end
      it "should reinstate a suspended project" do
        item = page.find('td.index_item', :text => "#{@projects[0].name}")
        item.click_link('Suspend')
        item = page.find('td.index_item', :text => "#{@projects[0].name}")
        item.should have_link('Reinstate')
        item.click_link('Reinstate')
        item = page.find('td.index_item', :text => "#{@projects[0].name}")
        item.should have_link('Suspend')
      end
    end
  end

  describe "TEAM" do
    before (:each) do
      @users = []
      3.times do |n|
        @users << create_user
        create_sponsorship(@account, @users[n], @user)
      end      
      
    end
    it "should show a link back to SHOW PROJECTS" do
      click_link("#{@account.name}")
      click_link("SHOW TEAM")
      page.should have_link("SHOW PROJECTS", :href => "#{account_path(@account)}?command=PROJECTS")
    end
    it "should show a list of users" do
      click_link("#{@account.name}")
      click_link("SHOW TEAM")
      page.should have_selector("td.index_item", :count=>4)
    end
    it "should not show a user that isn't in this account" do
      @users << create_user
      click_link("#{@account.name}")
      click_link("SHOW TEAM")
      page.should have_selector("td.index_item", :count=>4)
      page.should_not have_selector("td.index_item", :text => "#{@users.last.name}")
    end

    describe "where current user is not account admin" do
      before (:each) do
        @sponsorship = User.find(@user.id).sponsorships.where(:account_id => @account.id).first
        @sponsorship.current_user_id = @user.id
        @sponsorship.demote_access
        click_link("#{@account.name}")
        click_link("SHOW TEAM")
      end
      it "should not show invite user dialog" do
        page.should_not have_field('sponsorship_user_email')
      end     
      it "should not show suspend command on items" do
        item = page.find('td.index_item', :text => "#{@users.last.name}")
        item.should_not have_link('Suspend')
      end 
    end
    describe "where current user is account admin" do
      before (:each) do
        click_link  "#{@account.name}"    
        click_link("SHOW TEAM")
      end
      it "should show invite user dialog" do
        page.should have_field('sponsorship_user_email')  
      end
      it "should uninvite a user from the account" do
        item = page.find('td.index_item', :text => "#{@users.last.name}")
        item.should have_link('Uninvite')
        item.click_link('Uninvite')
        item = page.find('td.index_item', :text => "#{@users.last.name}")
        item.should have_link('Invite')
      end
      it "should add another user" do
        @users << create_user
        page.find_by_id 'sponsorship_user_email'
        fill_in "sponsorship_user_email", :with => "#{@users.last.email}"
        click_button "Invite"
        page.should have_selector("div.flash.success", :text => "#{@users.last.name}")        
        page.should have_selector("td.index_item", :count=>5)
        item = page.find('td.index_item', :text => "#{@users.last.name}")
        item.should have_link('Uninvite')
      end
    end
  end
end
require 'spec_helper'
require 'spec_models_helper'

#TOOL: save_and_open_page

describe "Projects#Show " do
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
    fill_in      "Email",    with: @user.email
    fill_in      "Password", with: @user.password  
    click_button "Sign in"
  end

  describe "MY PROJECT -" do
    it "should navigate from HOME to Projects#Show" do
      click_link   "#{@projects[0].name}"
      page.should have_selector('title', text: "Project")
      page.should have_link( "Home", href: "#{user_path(@user)}")
    end

    it "should navigate from HOME to Projects#Show back to HOME" do
      click_link   "#{@projects[0].name}"
      click_link "Home"
      page.should have_selector('title', text: "Home")
    end

    it "should navigate signedin user back to their last project" do
      click_link   "#{@projects[0].name}"
      visit root_path
      page.should have_selector('title', text: "Project")
      page.should have_selector('h1', text: "#{@projects[0].name}")
      page.should have_link("Home", href: "#{user_path(@user)}")
      page.should have_link("SHOW TEAM")
    end
    
    it "should navigate to HOME when user has lost auth for signed-in project" do
      pending
    end
    
    it "should navigate to HOME if cookie has expired" do
      pending
    end

    it "should have an account name link" do
      click_link   "#{@projects[0].name}"
      page.should have_link( "#{@account.name}", href: "#{account_path(@account)}")
    end
    
    it "should navigate to account projects index when account link clicked" do
      click_link   "#{@projects[0].name}"
      click_link   "#{@account.name}"
      page.should have_selector('title', text: "Account")
    end
    
    it "should navigate to account projects index and back" do
      click_link   "#{@projects[0].name}"
      click_link   "#{@account.name}"
      click_link   "#{@projects[0].name}"      
      page.should have_selector('title', text: "Project")
    end

    describe "where current user is not project admin" do
      before (:each) do
        @sponsorship = User.find(@user.id).sponsorships.where(:account_id => @account.id).first
        @sponsorship.current_user_id = @user.id
        @sponsorship.demote_access
#        click_link  "#{@account.name}"    
      end
      it "should show project page in non-admin mode" do
        pending
      end
    end

    describe "where current user is project admin" do
      before (:each) do
#        click_link  "#{@account.name}"    
      end
      it "should show project page in admin mode" do
        pending
      end
    end
  end

  describe "clicking MY TEAM -" do
    before (:each) do
      @users = []
      3.times do |n|
        @users << create_user
        create_sponsorship(@account, @users[n], @user)
        create_membership(@projects[0], @users[n], @user)
      end      
      click_link "#{@projects[0].name}"
      click_link "SHOW TEAM"
    end
    
    it "should have a working link to PROJECT HOME" do
      page.should have_link("SHOW PROJECT")
      click_link "SHOW PROJECT"
      page.should have_selector('title', text: "Project")
    end
    
    it "should show a list of project members" do
      page.should have_selector("td.item", :count=>4)
    end
    
    it "should not show a user that isn't in this project" do
      @users << create_user
      page.should have_selector("td.item", :count=>4)
      page.should_not have_selector("td.index_item", :text => "#{@users.last.name}")
    end

    describe "where current user is not project admin" do
      before (:each) do
        @sponsorship = User.find(@user.id).sponsorships.where(:account_id => @account.id).first
        @sponsorship.current_user_id = @user.id
        @sponsorship.demote_access
#        click_link("#{@account.name}")
#        click_link("SHOW TEAM")
      end
      it "should not show invite user dialog" do
        pending
        page.should_not have_field('sponsorship_user_email')
      end     
      it "should not show suspend command on items" do
        pending
        item = page.find('td.index_item', :text => "#{@users.last.name}")
        item.should_not have_link('Suspend')
      end 
    end
    describe "where current user is project admin" do
      before (:each) do
#        click_link  "#{@account.name}"    
#        click_link("SHOW TEAM")
      end
      it "should show invite user dialog" do
        pending
        page.should have_field('sponsorship_user_email')  
      end
      it "should uninvite a user from the project" do
        pending
        item = page.find('td.index_item', :text => "#{@users.last.name}")
        item.should have_link('Uninvite')
        item.click_link('Uninvite')
        item = page.find('td.index_item', :text => "#{@users.last.name}")
        item.should have_link('Invite')
      end
      it "should add another user" do
        pending
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
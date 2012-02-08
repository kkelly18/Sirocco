require 'spec_helper'
#TOOL: save_and_open_page

describe "User#Home" do
  it "should navigate a signedin user to Home " do
    user = Factory(:user)
    account = Factory(:account) #use as the personal account
    sponsorship = Factory(:sponsorship, :account_id => account.id, :user_id => user.id, :created_by => user.id, :current_user_id => user.id)
    project = Factory(:project, :account_id => account.id, :created_by => user.id)
    #memberships are created during active record callbacks

    visit root_path               
    click_link "Sign in"          

    page.should have_selector('title', :text => "Signin")  
    fill_in "Email",    :with => user.email
    fill_in "Password", :with => user.password  
    click_button "Sign in"

    page.should have_selector('title', :text => "Home")    

    visit root_path
    page.should have_selector('title', :text => "Home")    
  end

  it "should show a list of projects the user is a member of " do
    account = Factory(:account) #use as the personal account
    user = Factory(:user)
    sponsorship = Factory(:sponsorship, :account_id => account.id, :user_id => user.id, :created_by => user.id, :current_user_id => user.id)
    3.times do
      project = Factory(:project, :account_id => account.id, :created_by => user.id)
      #memberships are created during active record callbacks
    end    
    visit root_path               
    click_link "Sign in"          

    page.should have_selector('title', :text => "Signin")  
    fill_in "Email",    :with => user.email
    fill_in "Password", :with => user.password  
    click_button "Sign in"

    page.should have_selector('title', :text => "Home")    

    visit root_path
    page.should have_selector('title', :text => "Home")    
  end

  it "should show a list of accounts when 'MY ACCOUNTS' clicked " do
    @user = Factory(:user)
    3.times do
      @account = Factory(:account) #use as the personal account
      @sponsorship = Factory(:sponsorship, :account_id => @account.id, :user_id => @user.id, :created_by => @user.id, :current_user_id => @user.id)
      @project = Factory(:project, :account_id => @account.id, :created_by => @user.id)
      #memberships are created during active record callbacks
    end    
    visit root_path               
    click_link "Sign in"          

    page.should have_selector('title', :text => "Signin")  
    fill_in "Email",    :with => @user.email
    fill_in "Password", :with => @user.password  
    click_button "Sign in"

    page.should have_selector('title', :text => "Home")
    page.should have_link("MY ACCOUNTS", :href => "#{user_path(@user)}?command=ACCOUNTS" )    

    click_link "MY ACCOUNTS"
    page.should have_link("MY PROJECTS",  :href => "#{user_path(@user)}?command=PROJECTS"  )    

  end
end
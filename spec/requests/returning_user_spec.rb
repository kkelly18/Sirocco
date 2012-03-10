require 'spec_helper'
#TOOL: save_and_open_page

describe "User signin" do
  it "should allow an existing user to sign in" do
    account = Factory(:account) #use as the personal account
    user = Factory(:user)
    sponsorship = Factory(:sponsorship, account_id: account.id, user_id: user.id, created_by: user.id, current_user_id: user.id)
    3.times do
      project = Factory(:project, account_id: account.id, created_by: user.id)
      #memberships are created during active record callbacks
    end    
    visit root_path               
    click_link "Sign in"             

    page.should have_selector('title', text: "Signin")
  
    fill_in   "Email",    with: user.email
    fill_in   "Password", with: user.password
  
    click_button "Sign in"
    page.should have_selector('title',      text: "Home")
    page.should have_selector('nav li a',   href: signin_path, content: "Sign out")
    page.should have_selector('nav li',     content: user.name)
    page.should have_selector('nav li img', class: 'gravatar')
  end

  it "should prevent an unknown user from signing in" do
    visit root_path               
    click_link "Sign in"             
  
    fill_in   "Email",    with: "Unknown"
    fill_in   "Password", with: "foobar"
    
    click_button "Sign in"
    page.should have_selector("article div.flash.error", text: "Invalid")        
    page.should have_selector('title',    content: "Sign in")
    page.should have_selector("nav li a", href: signin_path, content: "Sign in")
  end
end

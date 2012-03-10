require 'spec_helper'
require 'spec_models_helper'

#TOOL: save_and_open_page

describe "New users can create a new project under their personal account" do
  it "should flash success given good attributes" do
    user = Factory(:user)
    visit root_path         
    click_link "signup_button"             
    fill_in   "Name",               with: user.name
    fill_in   "Email",              with: "user@email.com"
    fill_in   "Password",           with: user.password
    fill_in   "Confirm Password",   with: user.password_confirmation
    fill_in   "Account Name",       with: user.personal_account_name  
    click_button "Sign up"                
    fill_in "project_name", with: "First!"
    click_button "Create"
    page.should have_selector("div.flash.success", text: "First!")        
  end
end

describe "Existing users can create new projects under their personal account" do
  it "should flash success given good attrbutes" do
    @user        = create_user
    @account     = create_account(@user) 
    visit root_path               
    click_link   "Sign in"               
    fill_in      "Email",    with: @user.email
    fill_in      "Password", with: @user.password  
    click_button "Sign in"
    fill_in "project_name", with: "First!"
    click_button "Create"
    page.should have_selector("div.flash.success", text: "First!")            
  end
end

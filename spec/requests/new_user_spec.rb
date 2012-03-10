require 'spec_helper'
#TOOL: save_and_open_page

describe "New user signup" do
  describe "with valid attributes" do 
    it "should create a new user and leave them at the account#show page" do
        user = Factory(:user)
        visit root_path
        page.should have_selector('title', content: "Front")
        page.should have_link("sign_in_link", href: signin_path)
        page.should have_link("signup_button", href: signup_path)
               
        click_link "signup_button"             
        page.should have_selector('title', content: "Sign up")

        fill_in   "Name",               with: user.name
        fill_in   "Email",              with: "user@email.com"
        fill_in   "Password",           with: user.password
        fill_in   "Confirm Password",   with: user.password_confirmation
        fill_in   "Account Name",       with: user.personal_account_name
        
        click_button "Sign up"                
        page.should have_selector("div.flash.success", text: "Welcome")        
        page.should have_selector("h1", text: "#{user.personal_account_name}")
        page.should have_link("sign_out_link", href: signout_path)
        page.should have_link("#{user.name}")
                
    end
  end #signup happy path

  describe "with empty name" do
    it "should be sent back to the new user page" do
        visit root_path               
        click_link "Sign up now!"             

        fill_in   "Name",             with: ""
        fill_in   "Email",            with: "kevin.kelly@keltex.com"
        fill_in   "Password",         with: "foobar"
        fill_in   "Confirm Password", with: "foobar"        
        click_button "Sign up"                
        
        page.should have_selector('div', id: "error_explanation")
        page.should have_selector('li',  text: 'Name can\'t be blank')
        page.should have_link("sign_in_link", href: signin_path)
        
    end
  end
  
  describe "with invalid email" do
    it "should be sent back to the new user page" do
        visit root_path               
        click_link "Sign up now!"             

        fill_in   "Name",             with: "Kevin Kelly"
        fill_in   "Email",            with: "kevin.kelly.keltex.com"
        fill_in   "Password",         with: "foobar"
        fill_in   "Confirm Password", with: "foobar"
        click_button "Sign up"                

        page.should have_selector('div', id: "error_explanation")
        page.should have_selector('li',  text: 'Email is invalid')
        
    end
  end

  describe "with already used email" do
    it "should be sent back to the new user page" do
        first_user = Factory(:user)
        visit root_path               
        click_link "Sign up now!"             

        fill_in   "Name",             with: "Kevin Kelly"
        fill_in   "Email",            with: first_user.email
        fill_in   "Password",         with: "foobar"
        fill_in   "Confirm Password", with: "foobar"        
        click_button "Sign up"                

        page.should have_selector('li',  text: 'Email has already been taken')
        
    end
  end

  describe "invalid password" do
    it "should be sent back to the new user page" do
        first_user = Factory(:user)
        visit root_path               
        click_link "Sign up now!"             

        fill_in   "Name",             with: first_user.name
        fill_in   "Email",            with: "safe@email.com"
        fill_in   "Password",         with: "f"
        fill_in   "Confirm Password", with: "f"        
        click_button "Sign up"                
        
        page.should have_selector('li',  text: 'Password is too short (minimum is 6 characters)')
                
    end
  end

  describe "mismatched password" do
    it "should be sent back to the new user page" do
        first_user = Factory(:user)
        visit root_path               
        click_link "Sign up now!"             

        fill_in   "Name",             with: first_user.name
        fill_in   "Email",            with: "safe@email.com"
        fill_in   "Password",         with: first_user.password
        fill_in   "Confirm Password", with: "f"
        
        click_button "Sign up"                
        page.should have_selector('li',  text: 'Password doesn\'t match confirmation')
        
    end
  end

  describe "with invalid attributes" do
    it "should allow the user to fix and save" do
      first_user = Factory(:user)
      visit root_path               
      click_link "Sign up now!"             

      fill_in   "Name",             with: first_user.name
      fill_in   "Email",            with: "safe@email.com"
      fill_in   "Password",         with: first_user.password
      fill_in   "Confirm Password", with: "f"
      fill_in   "Account Name",     with: first_user.name
      
      click_button "Sign up"                
      page.should have_selector('li',  text: 'Password doesn\'t match confirmation')
    
      fill_in   "Password",         with: first_user.password
      fill_in   "Confirm Password", with: first_user.password_confirmation
      click_button "Sign up"
                      
     page.should have_selector("div.flash.success", text: "Welcome")        

    end
  end  

end

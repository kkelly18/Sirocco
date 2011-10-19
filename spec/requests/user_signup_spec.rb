require 'spec_helper'
#TOOL: save_and_open_page

describe "New user signup" do
  describe "with valid attributes" do 
    it "should create a new user and leave them at the account#show page" do
        visit root_path
        page.should have_selector('title', :content => "Front")   
        page.should have_selector("a", :href => signin_path, :content => "Sign in")
               
        click_link "Sign up now!"             
        page.should have_selector('title', :content => "Sign up")

        fill_in   "Name",             :with => "Kevin Kelly"
        fill_in   "Email",            :with => "kevin.kelly@keltex.com"
        fill_in   "Password",         :with => "foobar"
        fill_in   "Confirm Password", :with => "foobar"
        fill_in   "Account Name",     :with => "Kevin Kelly's Account"
        
        click_button "Sign up"                
        page.should have_selector("div.flash.success", :text => "Welcome")        
        page.should have_selector('nav li', :text => "Sign out")
save_and_open_page
        fill_in "project_name", :with => "First!"
        click_button "Create"
        page.should have_selector("div.flash.success", :text => "First")        
                
    end
  end #signup happy path

  describe "with empty name" do
    it "should be sent back to the new user page" do
        visit root_path               
        click_link "Sign up now!"             

        fill_in   "Name",             :with => ""
        fill_in   "Email",            :with => "kevin.kelly@keltex.com"
        fill_in   "Password",         :with => "foobar"
        fill_in   "Confirm Password", :with => "foobar"
        
        click_button "Sign up"                
        page.should have_selector('li', :text => "Sign in")
        page.should have_selector('div', :id => "error_explanation")
        page.should have_selector('li',  :text => 'Name can\'t be blank')
        
    end
  end
  
  describe "with invalid email" do
    it "should be sent back to the new user page" do
        visit root_path               
        click_link "Sign up now!"             

        fill_in   "Name",             :with => "Kevin Kelly"
        fill_in   "Email",            :with => "kevin.kelly.keltex.com"
        fill_in   "Password",         :with => "foobar"
        fill_in   "Confirm Password", :with => "foobar"
        
        click_button "Sign up"                
        page.should have_selector('li',  :text => 'Email is invalid')
        
    end
  end

  describe "with already used email" do
    it "should be sent back to the new user page" do
        first_user = Factory(:user)
        visit root_path               
        click_link "Sign up now!"             

        fill_in   "Name",             :with => "Kevin Kelly"
        fill_in   "Email",            :with => first_user.email
        fill_in   "Password",         :with => "foobar"
        fill_in   "Confirm Password", :with => "foobar"
        
        click_button "Sign up"                
        page.should have_selector('li',  :text => 'Email has already been taken')
        
    end
  end

  describe "invalid password" do
    it "should be sent back to the new user page" do
        first_user = Factory(:user)
        visit root_path               
        click_link "Sign up now!"             

        fill_in   "Name",             :with => first_user.name
        fill_in   "Email",            :with => "safe@email.com"
        fill_in   "Password",         :with => "f"
        fill_in   "Confirm Password", :with => "f"
        
        click_button "Sign up"                
        page.should have_selector('li',  :text => 'Password is too short (minimum is 6 characters)')
                
    end
  end

  describe "mismatched password" do
    it "should be sent back to the new user page" do
        first_user = Factory(:user)
        visit root_path               
        click_link "Sign up now!"             

        fill_in   "Name",             :with => first_user.name
        fill_in   "Email",            :with => "safe@email.com"
        fill_in   "Password",         :with => first_user.password
        fill_in   "Confirm Password", :with => "f"
        
        click_button "Sign up"                
        page.should have_selector('li',  :text => 'Password doesn\'t match confirmation')
        
    end
  end

  describe "with invalid attributes" do
    it "should allow the user to fix and save" do
      first_user = Factory(:user)
      visit root_path               
      click_link "Sign up now!"             

      fill_in   "Name",             :with => first_user.name
      fill_in   "Email",            :with => "safe@email.com"
      fill_in   "Password",         :with => first_user.password
      fill_in   "Confirm Password", :with => "f"
      fill_in   "Account Name",     :with => first_user.name
      
      click_button "Sign up"                
      page.should have_selector('li',  :text => 'Password doesn\'t match confirmation')
    
      fill_in   "Confirm Password", :with => first_user.password_confirmation
      click_button "Sign up"
                      
     page.should have_selector("div.flash.success", :text => "Welcome")        

    end
  end  

end

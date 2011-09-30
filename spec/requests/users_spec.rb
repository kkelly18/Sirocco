require 'spec_helper'

describe "New user" do
  describe "signup -- new project" do 
    it "Should create a new user and leave them at the account/project home page" do
        visit new_user_path
        page.should have_selector('title', :content => "Sign up")   
               
        fill_in   "Name",  :with => "Kevin Kelly"
        fill_in   "Email", :with => "kevin.kelly@keltex.com"
        fill_in   "Password", :with => "foobar"
        fill_in   "Confirm Password", :with => "foobar"

        click_button "Sign Up"                
        page.should have_selector('title', :content => "User Index")
        page.should have_selector('li', :text => "keltex")   
        #page.should have_selector("div.flash.success")
        save_and_open_page
    end
  end #signup happy path
  
end #New user

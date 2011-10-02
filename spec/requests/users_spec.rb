require 'spec_helper'

describe "New user" do
  describe "signup -- new project" do 
    it "Should create a new user and leave them at the account/project home page" do
        visit root_path
        page.should have_selector('title', :content => "Front")   
        page.should have_selector("a", :href => signin_path, :content => "Sign in")
               
        click_link "Sign up now!"             

        page.should have_selector('title', :content => "Sign up")
        fill_in   "Name",  :with => "Kevin Kelly"
        fill_in   "Email", :with => "kevin.kelly@keltex.com"
        fill_in   "Password", :with => "foobar"
        fill_in   "Confirm Password", :with => "foobar"

        click_button "Sign Up"                

        page.should have_selector('title', :content => "Sign in")
        page.should have_selector("div.flash.notice")

        fill_in   "Email", :with => "kevin.kelly@keltex.com"
        fill_in   "Password", :with => "foobar"
        
        click_button "Sign in"
        
        page.should have_selector('li', :text => "Sign out")
        page.should have_selector('li', :text => "keltex")   

        save_and_open_page

    end
  end #signup happy path
  
end #New user

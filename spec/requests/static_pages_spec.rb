require 'spec_helper'

describe "Static Pages" do
  describe "Home page" do
    
    it "should have the content 'Where meditators meet'" do
      visit '/'
      page.should have_content('Where meditators meet')
    end
  end
  
  describe "About page" do

    it "should have the content 'About'" do
      visit '/about'
      page.should have_selector('title',
                  :text => "About")
    end
  end
  
end
require 'spec_helper'

describe "Static pages" do

  subject { page }

  describe "Home page" do
    before { visit root_path }
    it { should have_selector('h1',    text: 'Where meditators meet.') }
  end

  describe "About page" do
    before { visit about_path }
    it { should have_selector('h1',    text: 'About') }
  end

  describe "Contact page" do
    before { visit contact_path }
    it { should have_selector('h1',    text: 'Contact us') }
  end

  describe "Contribute page" do
    before { visit contribute_path }
    it { should have_selector('h1',    text: 'Help us build OpenSit!') }
  end
end
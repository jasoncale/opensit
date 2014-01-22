require 'spec_helper'

describe 'Users' do

  subject { page }
  before do
    @buddha = create :user
  end

  it 'should register a new user' do
    visit '/'
    fill_in "user_username", with: "newbie"
    fill_in "user_email", with: "newbie@samsara.com"
    fill_in "user_password", with: "gunsbitchesbling"
    click_on "Sign up"

    should have_content "Welcome! You have signed up successfully."
  end

  describe 'registered users' do

    it 'should be able to log in' do
      visit user_session_path
      fill_in "user_email", with: "buddha@example.com"
      fill_in "user_password", with: "gunsbitchesbling"
      click_on "Sign in"

      should have_content "Signed in successfully."
    end
    
  end

  describe 'username urls' do
    context 'existing users' do
      it 'with /u' do
        visit "/u/buddha"
        expect(status_code).to eq 200
      end

      it 'case insensitive' do
        visit '/u/BuDdHa'
        expect(status_code).to eq 200
      end
    end

    it 'should return 404 for non-existent users' do
      visit '/u/jesus'
      expect(status_code).to eq 404
    end
  end

end
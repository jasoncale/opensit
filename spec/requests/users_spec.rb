require 'spec_helper'

describe 'Users' do

  subject { page }
  before do
    @buddha = create :user, username: "buddha"
  end

  it 'should register a new user' do
    visit new_user_registration_path
    fill_in "user_username", with: "newbie"
    fill_in "user_email", with: "newbie@samsara.com"
    fill_in "user_password", with: "gunsbitchesbling"

    within(".new_user") do
      find_button("Sign up").trigger('click')
    end

    should have_content "Registration complete! Happy sitting."
    should have_content "Welcome to our community!"
  end

  describe 'registered users' do

    it 'should be able to log in' do
      visit user_session_path
      fill_in "user_email", with: "#{@buddha.email}"
      fill_in "user_password", with: "#{@buddha.password}"

      within(".new_user") do
        click_on "Login"
      end

      should have_content "Welcome back!"
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
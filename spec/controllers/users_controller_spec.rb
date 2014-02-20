require 'spec_helper'

describe UsersController do
  before do
    @buddha = create(:user, username: 'buddha')
  end

  describe 'GET /me' do
    context 'signed in' do
      it 'should display the /me page' do
        sign_in @buddha
        get :me
        expect(response).to be_success
        expect(response).to render_template("users/me")
      end
    end

    context 'logged out' do
      it 'redirects to the front page' do
        get :me
        expect(response).to redirect_to('/front')
      end
    end
  end

  describe 'GET /u/:username' do
    it 'displays user page' do
      get :show, username: 'buddha'
      expect(assigns(:user)).to eq(@buddha)
      expect(response).to render_template("users/show")
    end
  end

  describe 'Profiles details and edit' do
    context 'someone elses' do
      it 'load profile' do
        @ananda = create :user, username: 'ananda', why: 'to get sat0ri'
        sign_in @buddha
        get :show, username: 'ananda'
        expect(assigns(:user)).to eq(@ananda)
        expect(response.body).to include('to get sat0ri')
        expect(response.body).to_not have_css('a.edit-profile-btn', text: 'Edit profile')
      end
    end
    context 'own profile' do
      it 'load profile with edit button' do
        @deva = create :user, username: 'deva', why: 'seduce lustful practitioners'
        sign_in @deva
        get :show, username: 'deva'
        expect(assigns(:user)).to eq(@deva)
        expect(response.body).to include('seduce lustful practitioners')
        expect(response.body).to have_css('a.edit-profile-btn', text: 'Edit profile')
      end
    end
  end

  describe 'GET /u/:username/following' do
    it 'loads following page' do
      sign_in @buddha
      get :following, username: 'buddha'
      expect(assigns(:user)).to eq(@buddha)
      expect(response).to be_success
      expect(response).to render_template("users/show_follow")
      expect(response.body).to have_selector('h3', text: 'People I follow')
    end
  end

  describe 'GET /u/:username/followers' do
    it 'loads followers page' do
      sign_in @buddha
      get :followers, username: 'buddha'
      expect(assigns(:user)).to eq(@buddha)
      expect(response).to be_success
      expect(response).to render_template("users/show_follow")
      expect(response.body).to have_selector('h3', text: 'People who follow me')
    end
  end

  describe 'GET /u/:username/export' do
    it 'returns XML' do
      sign_in @buddha
      get :export, username: 'buddha', format: 'xml'
      expect(response).to be_success
      expect(response.content_type).to eq("application/xml")
    end

    it 'returns JSON' do
      sign_in @buddha
      get :export, username: 'buddha', format: 'json'
      expect(response).to be_success
      expect(response.content_type).to eq("application/json")
    end
  end

  describe 'GET /feed' do
    before do
      @ananda = create :user, username: 'ananda'
      @sariputta = create :user, username: 'sariputta'

      create :sit, user: @ananda, body: 'un'
      create :sit, user: @sariputta, body: 'deux'
      create :sit, user: @sariputta, body: 'erpderp'
      create :sit, user: @buddha, body: 'trois'
      create :sit, user: @buddha, body: 'private!!!', private: true
    end

    context 'user feed' do
      it 'should generate an Atom feed' do
        get :feed, username: 'buddha', format: 'atom'

        expect(response).to be_success
        expect(response).to render_template("users/feed")
        expect(response.content_type).to eq("application/atom+xml")
      end

      it 'shows only posts from that user' do
        get :feed, username: 'sariputta', format: 'atom'

        expect(response.body).to include('deux')
        expect(response.body).to include('erpderp')
        expect(response.body).to_not include('un')
      end

      it 'should not include private posts' do
        get :feed, username: 'buddha', format: 'atom'

        expect(response.body).to include('trois')
        expect(response.body).to_not include('private!!!')
      end
    end

    context 'global feed' do
      before do
        get :feed, format: 'atom', scope: 'global'
      end

      it 'should generate an Atom feed' do
        expect(response).to be_success
        expect(response).to render_template("users/feed")
        expect(response.content_type).to eq("application/atom+xml")
      end

      it 'should include content from all users' do
        expect(response.body).to include('un')
        expect(response.body).to include('deux')
        expect(response.body).to include('trois')
      end

      it 'should not include private posts' do
        expect(response.body).to_not include('private!!!')
      end
    end
  end

end
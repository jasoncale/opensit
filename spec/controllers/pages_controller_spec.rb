require 'spec_helper'

describe PagesController do
  before do
    @buddha = create(:user, username: 'buddha')
  end

  describe 'Explore' do
    it 'loads the global sit stream' do
      sign_in @buddha
      get :explore
      expect(response).to be_success
    end

    it 'loads new sitters' do
      dudette = create :user, username: 'ladyperson'
      create :sit, user: dudette, created_at: Date.today

      get :new_sitters
      expect(assigns(:users)).to have(1).items
      expect(assigns(:users).first.username).to eq 'ladyperson'
      expect(response).to render_template('users/user_results')
    end
  end

end
require 'spec_helper'

describe PagesController do
  before do
    @buddha = create(:user, username: 'buddha')
  end

  describe 'GET /explore' do
    it 'loads' do
      sign_in @buddha
      get :explore
      expect(response).to be_success
    end
  end
end
require 'spec_helper'

describe UsersController do
  before do
    @buddha = create :user
  end

  describe 'GET show' do
    it 'should return 404 for non-existent users' do
      expect {
        get :show, username: 'doge'
      }.to raise_error(ActionController::RoutingError, 'Not Found')
    end
  end
end
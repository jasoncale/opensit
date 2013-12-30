require 'spec_helper'

describe User do
  it 'should create a user' do
    create :user
    user = User.first
    expect(User.count).to eq 1
    expect(user.username).to eq 'buddha'
  end

  it "should not allow username's that match a route name" do
    expect { create :user, username: 'front' }.to raise_error(
      ActiveRecord::RecordInvalid,
      "Validation failed: 'front' is reserved."
    )
  end
end

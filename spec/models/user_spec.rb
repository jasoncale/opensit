require 'spec_helper'

describe User do
  it 'should create a user' do
    create :user
    user = User.first
    expect(User.count).to eq 1
    expect(user.username).to eq 'buddha'
  end

  # Used when we had /username routes
  #
  # it "should not allow username's that match a route name" do
  #   expect { create :user, username: 'front' }.to raise_error(
  #     ActiveRecord::RecordInvalid,
  #     "Validation failed: 'front' is reserved."
  #   )
  # end

  it "should not allow spaces in the username" do
    expect { create :user, username: 'dan bartlett', email: 'dan@dan.com' }.to raise_error(
      ActiveRecord::RecordInvalid,
      "Validation failed: Username cannot contain spaces."
    )
  end
end

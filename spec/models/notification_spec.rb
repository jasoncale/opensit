require 'spec_helper'

describe Notification do
  # it { should respond_to(:email) }
  # it { should respond_to(:password) }
  # it { should respond_to(:password_confirmation) }
  # it { should respond_to(:remember_me) }

  describe 'on comment activity' do
    before :each do
      @buddha = create :user
      @sit = create :sit, user: @buddha
    end

    it "should create a notification when a user comments on someone else's sit" do
      @ananda = create :user, username: 'ananda'
      # Ananda comments on the buddha's sit
      create :comment, sit: @sit, user: @ananda
      expect(@buddha.notifications.unread.count).to eq 1
    end

    it 'should not send a notification when user comments on own sit' do
      # Buddha comments on his own sit
      create :comment, sit: @sit, user: @buddha
      expect(Notification.all.count).to eq 0
      expect(@buddha.notifications.unread.count).to eq 0
    end
  end

end
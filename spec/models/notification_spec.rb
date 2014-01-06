require 'spec_helper'

describe Notification do

  describe 'New comments' do
    before :each do
      @buddha = create :user
      @ananda = create :user, username: 'ananda'
      @sit = create :sit, user: @buddha
    end

    it "should create a notification when a user comments on someone else's sit" do
      # Ananda comments on the buddha's sit
      create :comment, sit: @sit, user: @ananda
      expect(@buddha.notifications.unread.count).to eq 1
      expect(@buddha.notifications.first.message)
        .to eq("ananda commented on your sit.")
    end

    it 'should not send a notification when user comments on own sit' do
      # Buddha comments on his own sit
      create :comment, sit: @sit, user: @buddha
      expect(Notification.all.count).to eq 0
      expect(@buddha.notifications.unread.count).to eq 0
    end

    it 'does not increment commenters count if same user posts multiple times' do
      # Ananda comments on buddha's sit... THREE TIMES
      create :comment, sit: @sit, user: @ananda
      create :comment, sit: @sit.reload, user: @ananda
      create :comment, sit: @sit.reload, user: @ananda

      expect(@sit.commenters.count).to eq 1
    end

    context 'notifies other participants' do

      before :each do
        @dave = create :user, username: 'dave'
        @jesus = create :user, username: 'jesus'
      end

      it 'notifies all others when a new comment is added' do  
        # Ananda comments on buddha's sit
        create :comment, sit: @sit, user: @ananda
        expect(@sit.commenters.count).to eq 1
        expect(@buddha.notifications.unread.count).to eq 1

        # So do dave and jesus
        create :comment, sit: @sit.reload, user: @dave
        create :comment, sit: @sit.reload, user: @jesus

        expect(@sit.commenters.count).to eq 3     
        expect(@buddha.notifications.unread.count).to eq 3
        expect(@ananda.notifications.unread.count).to eq 2
        expect(@dave.notifications.unread.count).to eq 1
        expect(@jesus.notifications.unread.count).to eq 0
        expect(Notification.all.count).to eq(6)
      end

      it 'lets user know someone else has contributed' do
        # Sit belongs to buddha. Ananda comments first
        create :comment, sit: @sit, user: @ananda
        create :comment, sit: @sit.reload, user: @dave

        expect(@ananda.notifications.first.message)
          .to eq("dave also commented on buddha's sit.")
      end

      it 'changes message if user is being notified about the owner commenting on their own sit' do
        # Sit belongs to buddha. Ananda comments first
        create :comment, sit: @sit, user: @ananda

        # Buddha responds
        create :comment, sit: @sit.reload, user: @buddha
      
        expect(@ananda.notifications.first.message)
          .to eq("buddha also commented on their own sit.")
      end

    end
  end

  describe 'New followers' do
    it 'notifies user about new follower' do
      @buddha = create :user
      @ananda = create :user, username: 'ananda'

      @buddha.follow!(@ananda)

      expect(@ananda.notifications.unread.count).to eq 1
      expect(@ananda.notifications.first.message)
        .to eq 'buddha is now following you!'
    end
  end

end
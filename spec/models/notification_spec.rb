require 'spec_helper'

describe Notification do
  it "has a valid factory" do
    expect(build(:notification)).to be_valid
  end

  describe 'New comments' do
    before :each do
      @buddha = create :user, username: 'buddha'
      @ananda = create :user, username: 'ananda'
      @sit = create :sit, user: @buddha
    end

    it "should create a notification when a user comments on someone else's sit" do
      # Ananda comments on the buddha's sit
      create :comment, sit: @sit, user: @ananda
      expect(@buddha.notifications.unread.count).to eq 1
      expect(@buddha.notifications.first.message)
        .to eq("ananda commented on your sit.")
      expect(@buddha.notifications.first.initiator).to eq @ananda.id
      expect(@buddha.notifications.first.object_type).to eq 'comment'
      expect(@buddha.notifications.first.object_id).to eq @sit.comments.first.id
    end

    it "links to the sit comment" do
      # Ananda comments on the buddha's sit
      @comment = create :comment, sit: @sit, user: @ananda
      expect(@buddha.notifications.first.link).to eq "#{sit_path(@sit)}\#comment-#{@comment.id}"
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
      @buddha = create :user, username: 'buddha'
      @ananda = create :user, username: 'ananda'

      @buddha.follow!(@ananda)

      expect(@ananda.notifications.unread.count).to eq 1
      expect(@ananda.notifications.first.message).to eq 'buddha is now following you!'
      expect(@ananda.notifications.first.link).to eq user_path(@buddha)
      expect(@ananda.notifications.first.initiator).to eq @buddha.id
      expect(@ananda.notifications.first.object_type).to eq 'follow'
      expect(@ananda.notifications.first.object_id).to eq @buddha.relationships.where(follower_id: @buddha.id, followed_id: @ananda.id).first.id
    end
  end

  describe 'Likes a sit' do
    it 'notifies user that sit was liked' do
      @buddha = create :user
      @ananda = create :user, username: 'ananda'
      @sit = create :sit, user: @buddha

      @ananda.like!(@sit)

      expect(@buddha.notifications.unread.count).to eq 1
      expect(@buddha.notifications.first.message).to eq 'ananda likes your entry.'
      expect(@buddha.notifications.first.link).to eq sit_path(@sit)
      expect(@buddha.notifications.first.initiator).to eq @ananda.id
      expect(@buddha.notifications.first.object_type).to eq 'like'
      expect(@buddha.notifications.first.object_id).to eq @sit.likes.first.id
    end
  end

end

# == Schema Information
#
# Table name: notifications
#
#  created_at :datetime
#  id         :integer          not null, primary key
#  initiator  :integer
#  link       :string(255)
#  message    :string(255)
#  updated_at :datetime
#  user_id    :integer
#  viewed     :boolean          default(FALSE)
#  object_type :string(255)
#  object_id  :integer
#

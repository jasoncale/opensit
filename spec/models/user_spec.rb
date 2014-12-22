require 'spec_helper'

describe User do
  it "has a valid factory" do
    expect(build(:user)).to be_valid
  end
  let(:user) { build(:user) }
  let(:buddha) { create(:buddha) }
  let(:ananda) { create(:ananda) }

  describe "associations" do
    it { should have_many(:sits).dependent(:destroy) }
    it { should have_many(:messages_received)
          .conditions(receiver_deleted: false)
          .class_name("Message")
          .with_foreign_key("to_user_id") }
    it { should have_many(:messages_sent)
          .conditions(sender_deleted: false)
          .class_name("Message")
          .with_foreign_key("from_user_id") }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:relationships)
          .with_foreign_key("follower_id")
          .dependent(:destroy) }
    it { should have_many(:followed_users)
          .through(:relationships)
          .source(:followed) }
    it { should have_many(:reverse_relationships)
          .with_foreign_key("followed_id")
          .class_name("Relationship")
          .dependent(:destroy) }
    it { should have_many(:followers)
          .through(:reverse_relationships)
          .source(:follower) }
    it { should have_many(:notifications).dependent(:destroy) }
    it { should have_many(:favourites) }
    it { should have_many(:goals).dependent(:destroy) }

    describe "#favourite_sits" do
      let(:fav_sit) { create(:sit, user: ananda) }
      let(:unfav_sit) { create(:sit, user: ananda) }
      let(:buddha_fav) do
        Favourite.create(user_id: buddha.id,
                         favourable_id: fav_sit.id,
                         favourable_type: "Sit")
      end
      it "returns a user's favorite sits" do
        buddha_fav.reload
        expect(buddha.favourite_sits).to match_array([fav_sit])
      end
    end
  end #associations

  context "after signup" do
    it 'sends welcome email' do
      ActionMailer::Base.deliveries.clear
      ActionMailer::Base.deliveries.should be_empty

      email = 'sahaj@samadhi.com'
      create :user, email: email

      ActionMailer::Base.deliveries.should_not be_empty
      ActionMailer::Base.deliveries.last.to.should == [email]
    end

    it 'follows opensit' do
      opensit = create :user, id: 97
      nagz = create :user, username: 'nagarjuna'
      expect(nagz.following?(opensit)).to be(true)
    end
  end

  describe "validations" do
    it { should ensure_length_of(:username).is_at_least(3).is_at_most(20) }
    it { should validate_uniqueness_of(:username) }

    it "should not allow spaces in the username" do
      expect { create :user, username: 'dan bartlett', email: 'dan@dan.com' }
        .to raise_error(
          ActiveRecord::RecordInvalid,
          "Validation failed: Username cannot contain spaces"
        )
    end

    # Used when we had /username routes
    #
    # it "should not allow usernames that match a route name" do
    #   expect { create :user, username: 'front' }.to raise_error(
    #     ActiveRecord::RecordInvalid,
    #     "Validation failed: Username 'front' is reserved"
    #   )
    # end
  end

  describe "#to_param" do
    it "returns the username of a user" do
      expect(buddha.to_param).to eq("buddha")
    end
  end

  describe "#city?" do
    context "when a user has a city" do
      before { user.city = Faker::Address.city }

      it "returns true" do
        expect(user.city?).to be(true)
      end
    end

    context "when a user doesn't have a city" do
      before { user.city = nil }

      it "returns false" do
        expect(user.city?).to be(false)
      end
    end
  end

  describe "#country?" do
    context "when a user has a country" do
      before { user.country = Faker::Address.country }

      it "returns true" do
        expect(user.country?).to be(true)
      end
    end

    context "when a user doesn't have a country" do
      before { user.country = nil }

      it "returns false" do
        expect(user.country?).to be(false)
      end
    end
  end

  describe "#location" do
    let(:user) { build(:user, city: "New York", country: "United States") }

     context "when a user has both a city and country" do
        it "returns both the city and country" do
          expect(user.location).to eq("New York, United States")
        end
     end

     context "when a user has a city but no country" do
        before { user.country = nil }

        it "returns only the city" do
          expect(user.location).to eq("New York")
        end
     end

     context "when a user has a country but no city" do
        before { user.city = nil }

        it "returns only the country" do
          expect(user.location).to eq("United States")
        end
     end

     context "when a user neither has a city nor a country" do
        before do
          user.city = nil
          user.country = nil
        end

        it "returns nil" do
          expect(user.location).to be(nil)
        end
     end
  end #location

  describe "#display_name" do
    context "when a user has no first name" do
      let(:user) { build(:user, :no_first_name) }

      it "returns the users' username" do
        expect(user.display_name).to eq("#{user.username}")
      end
    end

    context "when a user has a first name but no last name" do
      let(:user) { build(:user, :no_last_name, :has_first_name) }

      it "returns the users' first name" do
        expect(user.display_name).to eq("#{user.first_name}")
      end
    end

    context "when a user has both a first name and last name" do
      let(:user) { build(:user, :has_first_name, :has_last_name) }

      it "returns the users' first name and last name" do
        expect(user.display_name).to eq("#{user.first_name} #{user.last_name}")
      end
    end
  end #display_name

  describe "methods that interact with sits" do
    let(:public_sits) { create_list(:sit, 3, :public, user: ananda) }
    let(:first_sit) { create(:sit, :one_hour_ago, user: buddha) }
    let(:second_sit) do
      create(:sit, :two_hours_ago, user: buddha)
    end
    let (:third_sit) do
      create(:sit, :three_hours_ago, user: buddha)
    end
    let (:fourth_sit) do
      create(:sit, :one_year_ago, user: buddha)
    end
    let(:this_year) { Time.now.year }
    let(:this_month) { Time.now.month }

    describe "#latest_sit" do
      it "returns the latest sit for a user" do
        expect(buddha.latest_sit(buddha))
          .to eq [third_sit]
      end
      # it "does not return the public sits that do not belong to a user" do
      #   expect(buddha.latest_sit(buddha)).to_not match_array([public_sits])
      # end
    end

    describe "#sits_by_year" do
      it "returns all sits for a user for a given year" do
        expect(buddha.sits_by_year(this_year))
          .to match_array(
            [first_sit, second_sit, third_sit]
          )
      end

      it "does not include sits outside of a given year" do
        expect(buddha.sits_by_year(this_year))
          .to_not include(fourth_sit)
      end
    end

    describe "#sits_by_month" do
      it "returns all sits for a user for a given month and year" do
        expect(buddha.sits_by_month(month: this_month, year: this_year))
          .to match_array(
            [first_sit, second_sit, third_sit]
          )
      end

      it "does not include sits outside of a given month and year" do
        expect(buddha.sits_by_month(month: this_month, year: this_year))
          .to_not include(fourth_sit)
      end
    end

    describe "#sat_on_date?" do
      before do
        create(:sit, created_at: Date.yesterday, user: buddha)
      end

      it "return true if user sat" do
        expect(buddha.sat_on_date?(Date.yesterday)).to eq(true)
      end

      it "return false if user didn't sit" do
        expect(buddha.sat_on_date?(Date.today - 2)).to eq(false)
      end
    end

    describe '#days_sat_in_date_range' do
      before do
        2.times do |i|
          create(:sit, created_at: Date.yesterday - i, user: buddha)
        end
        # The below shouldn't count towards total as buddha already sat that day
        create(:sit, created_at: Date.yesterday - 1, user: buddha)
      end
      it 'returns number of days' do
        expect(buddha.sits.count).to eq 3
        expect(buddha.days_sat_in_date_range(Date.yesterday - 3, Date.today)).to eq(2)
      end
    end

    describe "#time_sat_on_date" do
      it 'returns total minutes sat that day' do
        2.times do
          create(:sit, created_at: Date.today, user: buddha, duration: 20)
        end
        expect(buddha.time_sat_on_date(Date.today)).to eq(40)
      end
    end

    describe "#sat_for_x_on_date?" do
      before do
        create(:sit, created_at: Date.yesterday, user: buddha, duration: 30)
      end
      it 'returns true if user has sat x minutes that day' do
        expect(buddha.sat_for_x_on_date?(30, Date.yesterday)).to eq(true)
      end

      it 'returns false if user sat for less than x minutes that day' do
        expect(buddha.sat_for_x_on_date?(31, Date.yesterday)).to eq(false)
      end
    end

    describe "#days_sat_for_min_x_minutes_in_date_range" do
      it 'should return correct number of days' do
        2.times do |i|
          create(:sit, created_at: Date.today - i, user: buddha, duration: 30)
        end
        expect(buddha.days_sat_for_min_x_minutes_in_date_range(30, Date.today - 2, Date.today)).to eq 2
      end

      it 'should only return 1 when user sat twice on that day' do
        # Hard learned lesson: creating two sits programatically on the same day gives them both identical timestamps, which
        # when the function in question performs .uniq on a date range can give a very misleading pass when it should fail!
        # This could cause problems in all kinds of functions that work with dates. Hence + i.seconds to keep them unique.
        2.times do |i|
          create(:sit, created_at: Date.today + i.seconds, user: buddha, duration: 30)
        end

        expect(buddha.days_sat_for_min_x_minutes_in_date_range(30, Date.today, Date.today)).to eq 1
      end
    end

    describe "#journal_range" do
      it "returns an array of arrays of dates and counts"
    end

    describe "#socialstream" do
      before do
        Relationship.create(followed_id: buddha.id, follower_id: ananda.id)
        first_sit
        second_sit
        third_sit
        fourth_sit
      end

      it "returns an array of other followed users' sits" do
        expect(ananda.socialstream).to eq(
          [first_sit, second_sit, third_sit, fourth_sit])
      end

      it "does not return the oldest sits first" do
        expect(ananda.socialstream).to_not eq(
          [fourth_sit, third_sit, second_sit, first_sit])
      end

      it "should not shows stubs in socialstream" do
        stub = create(:sit, user: buddha, body: '')
        has_body = create(:sit, user: buddha, body: 'In the seeing, only the seen')
        expect(buddha.sits.count).to eq(6)
        expect(ananda.socialstream.count).to eq(5)
        expect(ananda.socialstream).to_not include stub
      end
    end

    describe "#private_stream=" do
      context "when the argument is 'true'" do
        it "updates all of a user's sits to be private" do
          sit = create(:sit, :public, user: user)

          expect { user.private_stream=('true') }
            .to change { user.sits.where(private: true).count }.from(0).to(1)
        end

        it "sets the user's private stream to true" do
          expect { user.private_stream=('TRUE') }
            .to change { user.private_stream }.from(false).to(true)
        end
      end

      context "when the argument is 'false'" do
        it "updates all of a user's sits to not be private" do
          sit = create(:sit, :private, user: user)

          expect { user.private_stream=('false') }
            .to change { user.sits.where(private: false).count }.from(0).to(1)
        end

        it "sets the user's private stream to false" do
          user.private_stream = 'true'
          expect { user.private_stream=('FALSE') }
            .to change { user.private_stream }.from(true).to(false)
        end
      end

      context "when the argument is neither 'true' nor 'false'" do
        it "raises an ArgumentError" do
          expect { user.private_stream=('bad_argument') }.to raise_error(
            ArgumentError,
            "Argument must be either 'true' or 'false'"
          )
        end
      end
    end

    describe "#favourited?" do
      context "when a user has favorited the specified sit" do
        before { create(:favourite, user_id: buddha.id, favourable_id: 1) }

        it "returns true" do
          expect(buddha.favourited?(1)).to eq true
        end
      end

      context "when a user has not favorited the specified sit" do
        it "returns false" do
          expect(buddha.favourited?(2)).to eq false
        end
      end
    end

  end # methods that interact with sits

  describe "#following?" do
    context "when a user is following another user" do
      before do
        Relationship.create(follower_id: ananda.id, followed_id: buddha.id)
      end

      it "returns true" do
        expect(ananda.following?(buddha)).to eq(true)
      end
    end

    context "when a user is not following another user" do
      it "returns false" do
        expect(ananda.following?(buddha)).to eq(false)
      end
    end
  end

  describe "#follow!" do
    it "creates a relationship" do
      expect { ananda.follow!(buddha) }
        .to change { ananda.followed_users.count }.from(0).to(1)
    end

    it "sends a notification" do
      expect(Notification).to receive(:send_new_follower_notification)
        .with(buddha.id, an_instance_of(Relationship))
      ananda.follow!(buddha)
    end
  end

  describe "#unfollow!" do
    it "destroys a relationship" do
      Relationship.create(follower_id: ananda.id, followed_id: buddha.id)

      expect { ananda.unfollow!(buddha) }
        .to change { ananda.followed_users.count }.from(1).to(0)
    end
  end

  describe "#following_anyone?" do
    it 'checks if user is following any other users besides OpenSit' do
      opensit = create :user, id: 97
      buddha = create(:user)
      ananda = create(:user)

      expect(buddha.following?(opensit)).to be(true)
      expect(buddha.following_anyone?).to be(false)
      buddha.follow!(ananda)
      expect(buddha.following_anyone?).to be(true)
    end
  end

  describe "#users_to_follow" do
    it "suggests users to follow" do
      user = create(:user)
      buddha = create(:user)
      ananda = create(:user)
      anuruddha = create(:user)

      ananda.follow!(buddha)
      anuruddha.follow!(buddha)

      user.follow!(ananda)
      user.follow!(anuruddha)

      expect(user.users_to_follow).to match_array([buddha])
    end

    it "should not suggest the already followed users" do
      user = create(:user)
      buddha = create(:user)
      ananda = create(:user)
      anuruddha = create(:user)

      ananda.follow!(buddha)
      anuruddha.follow!(buddha)

      user.follow!(ananda)
      user.follow!(anuruddha)
      user.follow!(buddha)

      expect(user.users_to_follow).to eq([])
    end

    it "should not suggest myself" do
      user = create(:user)
      ananda = create(:user)
      anuruddha = create(:user)

      ananda.follow!(user)
      anuruddha.follow!(user)

      user.follow!(ananda)
      user.follow!(anuruddha)

      expect(user.users_to_follow).to eq([])
    end
  end

  describe "#unread_count" do
    context "when a user has unread messages" do
      before do
        2.times do
         create(:message, from_user_id: ananda.id, to_user_id: buddha.id)
       end
      end

      it "returns the count of a user's unread messages" do
        expect(buddha.unread_count).to eq(2)
      end
    end

    context "when a user has no unread messages" do
      before do
        create(:message, :read, from_user_id: ananda.id,
               to_user_id: buddha.id)
      end

      it "returns nil" do
        expect(buddha.unread_count).to be(nil)
      end
    end
  end

  describe "#new_notifications" do
    context "when a user has notifications that have not been viewed" do
      before { create(:notification, user: buddha, viewed: false) }

      it "returns the number of unviewed notification" do
        expect(buddha.new_notifications).to eq(1)
      end
    end

    context "when a user no unviewed notifications" do
      before { create(:notification, user: buddha, viewed: true) }

      it "returns nil" do
        expect(buddha.new_notifications).to be_nil
      end
    end
  end

  describe "#update_with_password" do
    context "when there is a password provided" do
      let(:params) { { password: "password", username: "new_username" } }
      it "updates a users attributes" do
        expect { buddha.update_with_password(params) }
          .to change { buddha.username }.from("buddha").to("new_username")
      end
    end

    context "when there is no password provided" do
      let(:params) { { username: "new_username" } }
      it "updates a user's attributes" do
        expect { buddha.update_with_password(params) }
          .to change { buddha.username }.from("buddha").to("new_username")
      end
    end
  end

  describe "::newest_users" do
    let(:oldest_user) { create(:user, created_at: 1.years.ago) }
    let(:five_recent_users_array) { create_list(:user, 5) }

    context "with no provided arguments" do
      it "returns the five most recent users" do
        expect(User.newest_users).to match_array(five_recent_users_array)
      end
    end

    context "with a number provided as arguments" do
      it "returns the correct amount of users" do
        oldest_user
        five_recent_users_array

        expect(User.newest_users(6).count).to eq(6)
      end
    end
  end

end

# == Schema Information
#
# Table name: users
#
#  authentication_token   :string(255)
#  authorised_users       :string(255)      default("")
#  avatar_content_type    :string(255)
#  avatar_file_name       :string(255)
#  avatar_file_size       :integer
#  avatar_updated_at      :datetime
#  city                   :string(255)
#  confirmation_sent_at   :datetime
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  country                :string(255)
#  created_at             :datetime         not null
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string(255)
#  default_sit_length     :integer          default(30)
#  dob                    :date
#  email                  :string(255)
#  encrypted_password     :string(128)      default(""), not null
#  failed_attempts        :integer          default(0)
#  first_name             :string(255)
#  gender                 :integer
#  id                     :integer          not null, primary key
#  last_name              :string(255)
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string(255)
#  locked_at              :datetime
#  password_salt          :string(255)
#  practice               :text
#  privacy_setting        :string(255)      default("public")
#  remember_created_at    :datetime
#  remember_token         :string(255)
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  sign_in_count          :integer          default(0)
#  sits_count             :integer          default(0)
#  streak                 :integer          default(0)
#  style                  :string(100)
#  unlock_token           :string(255)
#  updated_at             :datetime         not null
#  user_type              :integer
#  username               :string(255)
#  website                :string(100)
#  who                    :text
#  why                    :text
#

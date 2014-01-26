require 'spec_helper'

describe User do
  it "has a valid factory" do
    expect(build(:user)).to be_valid
  end
  let(:user) { build(:user) }

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

    describe "#favourite_sits" do
      let(:user) { create(:user) }
      let(:another_user) { create(:user, username: "another_user") }
      let(:fav_sit) { create(:sit, user: another_user) }
      let(:unfav_sit) { create(:sit, user: another_user) }
      let(:user_fav) do
        Favourite.create(user_id: user.id,
                         favourable_id: fav_sit.id,
                         favourable_type: "Sit")
      end
      it "returns a user's favorite sits" do
        user_fav.reload
        expect(user.favourite_sits).to match_array([fav_sit])
      end
    end
  end #associations

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

    it "should not allow usernames that match a route name" do
      expect { create :user, username: 'front' }.to raise_error(
        ActiveRecord::RecordInvalid,
        "Validation failed: Username 'front' is reserved"
      )
    end
  end

  describe "#to_param" do
    it "returns the username of a user" do
      user.username = "john"
      expect(user.to_param).to eq("john")
    end
  end

  describe "#has_city?" do
    context "when a user has a city" do
      let(:user) { build(:user, :has_city) }
      it "returns true" do
        expect(user.has_city?).to be(true)
      end
    end

    context "when a user doesn't have a city" do
      let(:user) { build(:user, :no_city) }
      it "returns false" do
        expect(user.has_city?).to be(false)
      end
    end
  end

  describe "#has_country?" do
    context "when a user has a country" do
      let(:user) { build(:user, :has_country) }
      it "returns true" do
        expect(user.has_country?).to be(true)
      end
    end

    context "when a user doesn't have a country" do
      let(:user) { build(:user, :no_country) }
      it "returns false" do
        expect(user.has_country?).to be(false)
      end
    end
  end

  describe "#location" do
    let(:user) {build(:user, city: "New York", country: "United States")}
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
      let(:user) { build(:user, :no_first_name, username: "Buddha") }
      it "returns the users' username" do
        expect(user.display_name).to eq("Buddha")
      end
    end

    context "when a user has a first name but no last name" do
      let(:user) { build(:user, :no_last_name, first_name: "John") }
      it "returns the users' first name" do
        expect(user.display_name).to eq("John")
      end
    end

    context "when a user has both a first name and last name" do
      let(:user) { build(:user, first_name: "John", last_name: "Smith") }
      it "returns the users' first name and last name" do
        expect(user.display_name).to eq("John Smith")
      end
    end
  end #display_name

  describe "methods that return sits" do
    let(:user) { create(:user) }
    let(:public_sits) { create_list(:sit, 3, :public) }
    let(:first_user_sit) { create(:sit, :one_hour_ago, user: user) }
    let(:second_user_sit) do
      create(:sit, :two_hours_ago, user: user)
    end
    let (:third_user_sit) do
      create(:sit, :three_hours_ago, user: user)
    end
    let (:fourth_user_sit) do
      create(:sit, :one_year_ago, user: user)
    end
    let(:this_year) { Time.now.year }
    let(:this_month) { Date.new.month }

    describe "#latest_sits" do
      it "returns the last 3 most recent sits for a user" do
        expect(user.latest_sits)
          .to match_array([first_user_sit, second_user_sit, third_user_sit])
      end
      it "does not return the public sits that do not belong to a user" do
        expect(user.latest_sits).to_not match_array([public_sits])
      end
    end

    describe "#sits_by_year" do
      it "returns all sits for a user for a given year" do
        expect(user.sits_by_year(this_year))
          .to match_array([first_user_sit, second_user_sit, third_user_sit])
      end

      it "does not include sits outside of a given year" do
        expect(user.sits_by_year(this_year))
          .to_not include(fourth_user_sit)
      end
    end

    describe "#sits_by_month" do
      it "returns all sits for a user for a given month and year" do
        expect(user.sits_by_month(month: this_month, year: this_year))
          .to match_array([first_user_sit, second_user_sit, third_user_sit])
      end
      it "does not include sits outside of a given month and year" do
        expect(user.sits_by_month(month: this_month, year: this_year))
          .to_not include(fourth_user_sit)
        end
    end
  end # methods that return sits

  describe "#stream_range" do
    it "returns an array of arrays of dates and counts"
  end

  describe "#following?" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user, username: "john") }

    context "when a user is following another user" do
      it "returns true" do
        Relationship.create(follower_id: user.id, followed_id: other_user.id)
        expect(user.following?(other_user)).to eq(true)
      end
    end

    context "when a user is not following another user" do
      it "returns false" do
        expect(user.following?(other_user)).to eq(false)
      end
    end
  end

  describe "#follow!" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user, username: "john") }

    it "creates a relationship" do
      expect { user.follow!(other_user) }
        .to change {
          user.followed_users.count
        }.from(0).to(1)
    end

    it "sends a notification" do
      expect(Notification).to receive(:send_notification)
        .with('NewFollower', other_user.id, { follower: user })
      user.follow!(other_user)
    end
  end

  describe "#unfollow!" do
    it "destroys a relationship" do
      user = create(:user)
      other_user = create(:user, username: "john")
      Relationship.create(follower_id: user.id, followed_id: other_user.id)

      expect { user.unfollow!(other_user) }
        .to change {
          user.followed_users.count
        }.from(1).to(0)
    end
  end

  describe "#socialstream" do
    it "returns an array of sits of other followed users"
    it "sorts the sits from newest to oldest"
  end

  describe "#unread_count" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user, username: "john") }

    context "when a user has unread messages" do
      before do
        2.times do
         create(:message, from_user_id: other_user.id, to_user_id: user.id)
       end
      end

      it "returns the count of a user's unread messages" do
        expect(user.unread_count).to eq(2)
      end
    end

    context "when a user has no unread messages" do
      before do
        create(:message, :read, from_user_id: other_user.id,
               to_user_id: user.id)
      end

      it "returns nil" do
        expect(user.unread_count).to be(nil)
      end
    end
  end

  describe "#favourited?" do
    let(:user) { create(:user) }

    context "when a user has favorited the specified sit" do
      before { create(:favourite, user_id: user.id, favourable_id: 1) }
      it "returns true" do
        expect(user.favourited?(1)).to be_true
      end
    end

    context "when a user has not favorited the specified sit" do
      it "returns false" do
        expect(user.favourited?(2)).to be_false
      end
    end
  end

  describe "#new_notifications" do
    it "returns the number of unread notification"
  end

  describe "#private_stream=" do
    context "when the parameter is 'true'" do
      it "updates all of a user's sits to be private"
      it "sets the user's private stream to true"
    end

    context "when the parameter is 'false'" do
      it "updates all of a user's sits to not be private"
      it "sets the user's private stream to false"
    end
  end

  describe "#update_with_password" do
    context "with no password provided" do
      it "updates a user's attributes"
    end
  end

  describe "::newest_users" do
    context "with no provided arguments" do
      it "returns the five most recent users"
    end

    context "with a number provided as arguments" do
      it "returns the correct amount of users"
    end
  end


end

# == Schema Information
#
# Table name: users
#
#  authentication_token   :string(255)
#  avatar_content_type    :string(255)
#  avatar_file_name       :string(255)
#  avatar_file_size       :integer
#  avatar_updated_at      :datetime
#  city                   :string(255)
#  confirmation_sent_at   :datetime
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  country                :string(255)
#  created_at             :datetime
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
#  private_diary          :boolean
#  private_stream         :boolean          default(FALSE)
#  remember_created_at    :datetime
#  remember_token         :string(255)
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  sign_in_count          :integer          default(0)
#  style                  :string(100)
#  unlock_token           :string(255)
#  updated_at             :datetime
#  user_type              :integer
#  username               :string(255)
#  website                :string(100)
#  who                    :text
#  why                    :text
#

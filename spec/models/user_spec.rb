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
    it { should have_many(:favourites) }
    it { should have_many(:notifications).dependent(:destroy) }
  end

  describe "validations" do
    it { should ensure_length_of(:username).is_at_least(3).is_at_most(20) }
    it { should validate_uniqueness_of(:username) }

    it "should not allow spaces in the username" do
      expect { create :user, username: 'dan bartlett', email: 'dan@dan.com' }.to raise_error(
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
    it "returns the username of a user"
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

  describe "#latest_sits" do
    context "when the user is the same as the current user" do
      it "returns the last 3 most recent sits for a user"
    end

    context "when the user is not the same as the current user" do
      it "returns the last 3 public sits"
    end
  end

  describe "#sits_by_year" do
    it "returns all sits for a user for a given year"
  end

  describe "#sits_by_month" do
    it "returns all sits for a user for a given month and year"
  end

  describe "#stream_range" do
    it "returns an array of arrays of dates and counts"
  end

  describe "#following?" do
    context "when a user follows another user" do
      it "returns true"
    end

    context "when a user does not follow another user" do
      it "returns false"
    end
  end

  describe "#follow!" do
    it "creates a relationship"
    it "sends a notification"
  end

  describe "#unfollow!" do
    it "destroys a relationship"
  end

  describe "#socialstream" do
    it "returns an array of sits of other followed users"
    it "sorts the sits from newest to oldest"
  end

  describe "#unread_count" do
    it "returns the count of a user's unread messages"
  end

  describe "#favourited?" do
    context "when a user has favorited the specified sit" do
      it "returns true"
    end

    context "when a user has not favorited the specified sit" do
      it "returns false"
    end
  end

  describe "#get_favourites" do
    it "returns a user's favorites"
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

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
        "Validation failed: Username cannot contain spaces."
      )
    end

    it "should not allow usernames that match a route name" do
      expect { create :user, username: 'front' }.to raise_error(
        ActiveRecord::RecordInvalid,
        "Validation failed: 'front' is reserved."
      )
    end
  end

  describe "#prevent_empty_spaces" do
    context "when given a username with spaces" do
      let(:user_with_spaces) { build(:user, username: "name with spaces")}
      it "increments the number of errors on a user" do
        expect { user_with_spaces.prevent_empty_spaces }
          .to change { user_with_spaces.errors.size }
          .from(0).to(1)
      end

      it "returns an array containing: 'cannot contain spaces'" do
        expect(user_with_spaces.prevent_empty_spaces).to match_array(["cannot contain spaces."])
      end
    end

    context "when given a username with no spaces" do
      it "does not increment the number of errors on a user" do
        expect { user.prevent_empty_spaces }
          .not_to change { user.errors.size }
          .from(0).to(1)
      end

      it "returns nil" do
        expect(user.prevent_empty_spaces).to be(nil)
      end
    end
  end #prevent_empty_spaces

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

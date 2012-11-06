# == Schema Information
#
# Table name: users (NOTE: Devise fields removed)
#
#  id                   :integer          not null, primary key
#  username             :string(255)
#  email                :string(255)
#  profile_pic          :string(255)
#  first_name           :string(255)
#  last_name            :string(255)
#  dob                  :date
#  gender               :integer
#  city                 :string(255)
#  country              :string(255)
#  who                  :text
#  why                  :text
#  style                :text
#  practice             :text
#  public_diary         :boolean
#  default_sit_length   :integer
#  user_type            :integer
#

class User < ActiveRecord::Base
  attr_accessible :city, :country, :website, :default_sit_length, :dob, :password,
                  :email, :first_name, :gender, :last_name, :practice, :private_diary, :style, 
                  :user_type, :username, :who, :why, :password_confirmation, :remember_me, :avatar
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # CarrierWave
  mount_uploader :avatar, AvatarUploader

  # Pagination: sits per page
  self.per_page = 10

  has_many :sits, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower

  # Overwrite Devise function to allow profile update with password requirement
  # http://stackoverflow.com/questions/4101220/rails-3-devise-how-to-skip-the-current-password-when-editing-a-registratio?rq=1
  def update_with_password(params={})
    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end
    update_attributes(params)
  end

  # Return location
  def location
    if !self.city.blank? && !self.country.blank?
      "#{self.city}, #{self.country}"
    elsif !self.city.blank?
      "#{self.city}"
    elsif !self.country.blank?
      "#{self.country}"
    else
    end
  end
  
  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end

  def feed
    Sit.from_users_followed_by(self)
  end
end

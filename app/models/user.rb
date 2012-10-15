# == Schema Information
#
# Table name: users
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
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  encrypted_password   :string(128)      default(""), not null
#  password_salt        :string(255)
#  authentication_token :string(255)
#  confirmation_token   :string(255)
#  confirmed_at         :datetime
#  confirmation_sent_at :datetime
#  reset_password_token :string(255)
#  remember_token       :string(255)
#  remember_created_at  :datetime
#  sign_in_count        :integer          default(0)
#  current_sign_in_at   :datetime
#  last_sign_in_at      :datetime
#  current_sign_in_ip   :string(255)
#  last_sign_in_ip      :string(255)
#  failed_attempts      :integer          default(0)
#  unlock_token         :string(255)
#  locked_at            :datetime
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  # CarrierWave
  mount_uploader :avatar, AvatarUploader
  
  has_many :sits, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  
  attr_accessible :city, :country, :default_sit_length, :dob, :password,
                  :email, :first_name, :gender, :last_name, :practice, :private_diary, :style, 
                  :user_type, :username, :who, :why, :password_confirmation, :remember_me, :avatar

  # Overwrite Devise function to allow profile update with password requirement
  # http://stackoverflow.com/questions/4101220/rails-3-devise-how-to-skip-the-current-password-when-editing-a-registratio?rq=1
  def update_with_password(params={}) 
    if params[:password].blank? 
      params.delete(:password) 
      params.delete(:password_confirmation) if params[:password_confirmation].blank? 
    end 
    update_attributes(params) 
  end
end

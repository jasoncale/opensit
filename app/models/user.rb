# == Schema Information
#
# Table name: users
#
#  id                   :integer          not null, primary key
#  username             :string(255)
#  email                :string(255)
#  first_name           :string(255)
#  last_name            :string(255)
#  dob                  :date
#  gender               :integer
#  city                 :string(255)
#  country              :string(255)
#  who                  :text
#  why                  :text
#  style                :string(100)
#  practice             :text
#  private_diary        :boolean
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
#  avatar               :string(255)
#  website              :string(100)
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
  has_many :messages_received,  :class_name => 'Message', :foreign_key=> 'to_user_id', :conditions => { :receiver_deleted => false }
  has_many :messages_sent,      :class_name => 'Message', :foreign_key=> 'from_user_id', :conditions => { :sender_deleted => false }
  has_many :comments, :dependent => :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower
  has_many :favourites

  ##
  # VIRTUAL ATTRIBUTES
  ##

  # Location based on whether/if city and country have been entered
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

  ##
  # METHODS
  ##

  def sits_by_year(year)
    Sit.where("strftime('%Y', created_at) = ? AND user_id = ?", 
      year.to_s, self.id)
  end

  def sits_by_month(year, month)
    Sit.where("strftime('%Y', created_at) = ? AND strftime('%m', created_at) = ? AND user_id = ?",
      year.to_s, month.to_s.rjust(2, '0'), self.id)
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

  def socialstream
    Sit.from_users_followed_by(self).newest_first
  end

  def unread_count
    messages_received.unread.count unless messages_received.unread.count.zero?
  end

  # Has this user favourited this sit?
  def favourited?(id)
    @sit = Sit.find_by_id(id)
    @sit.favourites.where(:user_id => self.id).exists?
  end

  # Return a users favourites.
  # Options:
  #  :type (string) - defaults to Sit
  #  :id (int) - select by favourable_id
  #  :delve (bool) - return the favourited objects themselves
  def get_favourites(opts={})
  
    type = opts[:type] ? opts[:type] : :sit
    type = type.to_s.capitalize

    con = ["user_id = ? AND favourable_type = ?", self.id, type]
    
    if opts[:id]
      con[0] += " AND favourable_id = ?"
      con << opts[:id].to_s
    end
   
    favs = Favourite.all(:conditions => con)
    
    case opts[:delve]
    when nil, false, :false
      return favs
    when true, :true
      # Get a list of all favourited object ids
      fav_ids = favs.collect{|f| f.favourable_id}

      if fav_ids.size > 0
        type_class = type.constantize
        return type_class.find(fav_ids)
      else
        return []
      end
    end       
  end

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

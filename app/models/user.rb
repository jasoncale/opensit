class User < ActiveRecord::Base
  attr_accessible :city, :country, :website, :default_sit_length, :dob,
                  :password, :email, :first_name, :gender, :last_name, 
                  :practice, :private_diary, :style, :user_type, :username, 
                  :who, :why, :password_confirmation, :remember_me, :avatar,
                  :private_stream

  has_many :sits, :dependent => :destroy
  has_many :messages_received, -> { where receiver_deleted: false }, class_name: 'Message', foreign_key: 'to_user_id'
  has_many :messages_sent, -> { where sender_deleted: false }, class_name: 'Message', foreign_key: 'from_user_id'
  has_many :comments, :dependent => :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower
  has_many :favourites
  has_many :notifications, :dependent => :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  # Devise :validatable (above) covers validation of email and password
  validates :username, length: {minimum: 3, maximum: 10}
  validates_uniqueness_of :username

  # Pagination: sits per page
  self.per_page = 10

  # Paperclip
  has_attached_file :avatar, styles: {
    small_thumb: '50x50#',
    thumb: '200x200#',
  }

  scope :newest_first, -> { order("created_at DESC") }

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

  def display_name
    if self.first_name.blank?
      self.username
    else
      "#{self.first_name} #{self.last_name}"
    end
  end

  ##
  # METHODS
  ##

  def latest_sits
    self.sits.newest_first.limit(3)
  end

  def sits_by_year(year)
    Sit.where("EXTRACT(year FROM created_at) = ? AND user_id = ?", 
      year.to_s, self.id)
  end

  def sits_by_month(year, month)
    Sit.where("EXTRACT(year FROM created_at) = ? AND EXTRACT(month FROM created_at) = ? AND user_id = ?",
      year.to_s, month.to_s.rjust(2, '0'), self.id)
  end

  def stream_range
    return false if self.sits.empty?

    first_sit = Sit.where("user_id = ?", self.id).order(:created_at).first.created_at.strftime("%Y %m").split(' ')
    year, month = Time.now.strftime("%Y %m").split(' ')
    dates = []
    
    # Build list of all months from first lsit to current date
    while [year.to_s, month.to_s.rjust(2, '0')] != first_sit
      month = month.to_i
      year = year.to_i
      if month != 0
        dates << [year, month]
        month -= 1
      else
        year -= 1
        month = 12
      end
    end

    # Add first sit month
    dates << [first_sit[0].to_i, first_sit[1].to_i]

    # Filter out any months with no activity
    pointer = 1900
    links = []
    dates.each do |m|
      year, month = m
      month_total = self.sits_by_month(year, month).count

      if pointer != year
        year_total = self.sits_by_year(year).count
        links <<  [year, year_total]
      end
      
      if month_total != 0
        links << [month, month_total]
      end
      
      pointer = year
    end
    
    return links
  end

  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
    Notification.send_notification('NewFollower', other_user.id, { follower: self })
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

    favs = Favourite.where(user_id: self.id).where(favourable_type: type)

    if opts[:id]
      favs.where(favourable_id: opts[:id].to_s)
    end
    
    case opts[:delve]
    when nil, false, :false
      return favs
    when true, :true
      # Get a list of all favourited object ids
      # TODO: somehow order these by order in which they were favourited!
      fav_ids = favs.collect{|f| f.favourable_id}

      if fav_ids.size > 0
        type_class = type.constantize
        return type_class.where(id: fav_ids).where(private: false)
      else
        return []
      end
    end       
  end

  def new_notifications
    notifications.unread.count unless notifications.unread.count.zero?
  end

  def private_stream=(value)
    if value == '1'
      self.sits.update_all(private: true)
    elsif value == '0'
      self.sits.update_all(private: false)
    end
    write_attribute(:private_stream, value)
  end

  ##
  # CLASS METHODS
  ##

  def self.newest_users(count = 5)
    self.limit(count).newest_first
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

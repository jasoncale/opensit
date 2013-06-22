class Sit < ActiveRecord::Base
  attr_accessible :disable_comments, :tag_list, :duration, :s_type, :body, :title, :created_at, :user_id
  
  belongs_to :user
  has_many :comments, :dependent => :destroy
  has_many :taggings
  has_many :tags, through: :taggings
  has_many :favourites, :as => :favourable

  
  validates :body, :presence => true
  validates :s_type, :presence => true
  validates :title, :presence => true, :if => "s_type != 0"
  validates :duration, :presence => true, :if => "s_type == 0"

  # Scopes
  scope :newest_first, order("created_at DESC")
  
  # Pagination: sits per page
  self.per_page = 10

  ##
  # VIRTUAL ATTRIBUTES
  ##

  # Nice date: 11 July 2012
  def date
    created_at.strftime("%d %B %Y")
  end

  # For use on show sit pages
  def full_title
    if s_type == 0
      "#{self.duration} minute sit"
    elsif s_type == 1
      self.title # Diary
    else
      "Article: #{self.title}" # Article
    end
  end

  ##
  # METHODS
  ##

  def mine?(current)
    return true if self.user_id == current.id
  end

  def next
    user.sits.where("id > ?", id).first
  end

  def prev
    user.sits.where("id < ?", id).last
  end

  # Returns sits from the users being followed by the given user.
  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", 
          user_id: user.id)
  end

  # Tags

  def self.tagged_with(name)
    Tag.find_by_name!(name).sits
  end

  def self.tag_counts
    Tag.select("tags.*, count(taggings.tag_id) as count").
      joins(:taggings).group("taggings.tag_id")
  end

  def tag_list
    tags.map(&:name).join(', ')
  end

  def tag_list=(names)
    self.tags = names.split(",").map do |n|
      Tag.where(name: n.strip).first_or_create!
    end
  end
end                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        # 

require 'textacular/searchable'

class Sit < ActiveRecord::Base
  attr_accessible :private, :disable_comments, :tag_list, :duration, :s_type,
                  :body, :title, :created_at, :user_id, :views

  belongs_to :user, counter_cache: true
  has_many :comments, :dependent => :destroy
  has_many :taggings
  has_many :tags, through: :taggings
  has_many :favourites, :as => :favourable
  has_many :likes, :as => :likeable

  validates :s_type, :presence => true
  validates :title, :presence => true, :if => "s_type != 0"
  validates :duration, :presence => true, :if => "s_type == 0"
  validates_numericality_of :duration, greater_than: 0, only_integer: true

  # Scopes
  scope :public, -> { where(private: false) }
  scope :newest_first, -> { order("created_at DESC") }
  scope :today, -> { where("DATE(created_at) = ?", Date.today) }
  scope :yesterday, -> { where("DATE(created_at) = ?", Date.yesterday) }
  scope :with_body, -> { where.not(body: '')}

  # Pagination: sits per page
  self.per_page = 20

  # Textacular: search these columns only
  extend Searchable(:title, :body)

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
      "#{self.duration} minute meditation sit"
    elsif s_type == 1
      self.title # Diary
    else
      "Article: #{self.title}" # Article
    end
  end

  ##
  # METHODS
  ##

  def is_sit?
    s_type == 0
  end

  # Remove <br>'s and &nbsp's
  def custom_strip
    no_brs = self.body.gsub(/<br>/, ' ')
    no_brs.gsub('&nbsp;', ' ')
  end

  def mine?(current)
    return true if self.user_id == current.id
  end

  def next(current_user)
    next_sit = user.sits.with_body.where("created_at > ?", self.created_at).order('created_at ASC')
    return next_sit.first if current_user && (self.user_id == current_user.id)
    return next_sit.public.first
  end

  def prev(current_user)
    prev_sit = user.sits.with_body.where("created_at < ?", self.created_at).order('created_at ASC')
    return prev_sit.last if current_user && (self.user_id == current_user.id)
    return prev_sit.public.last
  end

  # Returns sits from the users being followed by the given user.
  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"

    where("(user_id IN (#{followed_user_ids}) AND private = false) OR user_id = :user_id",
          user_id: user.id)
  end

  def commenters
    ids = self.comments.map {|c| c.user.id}.uniq # uniq removes dupe ids if someone's posted multiple times
    ids.delete(self.user.id) # remove owners id
    return ids
  end

  ##
  # TAGS
  ##

  def self.tagged_with(name)
    Tag.find_by_name!(name).sits.public
  end

  def self.tag_counts
    Tag.select("tags.*, count(taggings.tag_id) as count").
      joins(:taggings).group("taggings.tag_id, tags.id, tags.name, tags.created_at")
  end

  def tag_list
    tags.map(&:name).join(', ')
  end

  def tag_list=(names)
    self.tags = names.split(",").map do |n|
      Tag.where(name: n.strip).first_or_create!
    end
  end

  ##
  # LIKES
  ##

  def likers
    Like.likers_for(self)
  end

  def liked?
    !self.likes.empty?
  end

end
# == Schema Information
#
# Table name: sits
#
#  body             :text
#  created_at       :datetime         not null
#  disable_comments :boolean
#  duration         :integer
#  id               :integer          not null, primary key
#  private          :boolean          default(FALSE)
#  s_type           :integer
#  title            :string(255)
#  updated_at       :datetime         not null
#  user_id          :integer
#  views            :integer          default(0)
#

class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :sit
  has_many :likes, :as => :likeable

  attr_accessible :body, :sit_id, :user_id

  validates :body, :presence => true

  scope :newest_first, -> { order("created_at DESC") }

  self.per_page = 10

  after_save :create_notification

  def self.latest(count = 5)
    self.newest_first.limit(count)
  end

  def likers
    Like.likers_for(self)
  end

  private
    def create_notification
      commenters = self.sit.commenters

      # Notify the owner of the sit
      Notification.send_new_comment_notification(self.sit.user.id, { commenter: self.user, sit_id: self.sit.id, comment_id: self.id, mine: true })

      # And any other commenters
      if !commenters.empty?
        commenters.each do |c|
          Notification.send_new_comment_notification(c, { commenter: self.user, sit_id: self.sit.id, comment_id: self.id, sit_owner: self.sit.user.display_name })
        end
      end
    end
end

# == Schema Information
#
# Table name: comments
#
#  body       :text
#  created_at :datetime         not null
#  id         :integer          not null, primary key
#  sit_id     :integer
#  updated_at :datetime         not null
#  user_id    :integer
#

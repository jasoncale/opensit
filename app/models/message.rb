class Message < ActiveRecord::Base
  belongs_to :from_user,  :class_name => 'User'
  belongs_to :to_user,    :class_name => 'User'
  
  attr_accessible :body, :subject, :from_user_id, :to_user_id, :read

  validates :body, :from_user_id, :to_user_id, :presence => true

  scope :unread, -> { where(read: false) }
  scope :newest_first, -> { order("created_at DESC") }

  ##
  # VIRTUAL ATTRIBUTES
  ##

  def received_at
    created_at.strftime("%l:%M%P, %d %B %Y")
  end

  ##
  # METHODS
  ##

  def mark_as_read
    self.read = true
    self.save
  end

  def send_message(recipients)
    if recipients.is_a?(Array)
      recipients.each do |to|
        msg = self.clone
        msg.id = nil # Prevent non-unique primary key
        msg.to_user_id = to
        return true if msg.save
        return false
      end
    end
  end
end

# == Schema Information
#
# Table name: messages
#
#  body             :text
#  created_at       :datetime         not null
#  from_user_id     :integer
#  id               :integer          not null, primary key
#  read             :boolean          default(FALSE)
#  receiver_deleted :boolean          default(FALSE)
#  sender_deleted   :boolean          default(FALSE)
#  subject          :string(255)
#  to_user_id       :integer
#  updated_at       :datetime         not null
#

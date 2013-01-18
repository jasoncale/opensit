class Message < ActiveRecord::Base
  belongs_to :from_user,  :class_name => 'User'
  belongs_to :to_user,    :class_name => 'User'
  
  attr_accessible :body, :subject, :from_user_id, :to_user_id, :read

  validates :body, :from_user_id, :to_user_id, :presence => true

  def send_message(recipients)
    if recipients.is_a?(Array)
      recipients.each do |to|
        msg = self.clone
        msg.id = nil # Prevent non-unique primary key
        msg.to_user_id = to
        msg.save
      end
    end
  end
end

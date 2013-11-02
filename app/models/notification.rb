class Notification < ActiveRecord::Base
  attr_accessible :user_id, :notification_type, :viewed, :meta

  belongs_to :user

  validates_presence_of :user_id, :notification_type
end

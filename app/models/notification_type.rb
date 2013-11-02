class NotificationType < ActiveRecord::Base
  attr_accessible :event, :text
  validates_presence_of :event, :text
end

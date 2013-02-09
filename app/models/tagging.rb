class Tagging < ActiveRecord::Base
  belongs_to :tag
  belongs_to :sit
  # attr_accessible :title, :body
end

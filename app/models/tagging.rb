class Tagging < ActiveRecord::Base
  belongs_to :tag
  belongs_to :sit
  # attr_accessible :title, :body
end

# == Schema Information
#
# Table name: taggings
#
#  created_at :datetime
#  id         :integer          not null, primary key
#  sit_id     :integer
#  tag_id     :integer
#  updated_at :datetime
#
# Indexes
#
#  index_taggings_on_sit_id  (sit_id)
#  index_taggings_on_tag_id  (tag_id)
#

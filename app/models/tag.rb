class Tag < ActiveRecord::Base
  attr_accessible :name

  has_many :taggings
	has_many :sits, through: :taggings
end

# == Schema Information
#
# Table name: tags
#
#  created_at :datetime
#  id         :integer          not null, primary key
#  name       :string(255)
#  updated_at :datetime
#

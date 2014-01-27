require 'spec_helper'

describe Tagging do
  it { should belong_to(:tag) }
  it { should belong_to(:sit) }
end

# == Schema Information
#
# Table name: taggings
#
#  created_at :datetime         not null
#  id         :integer          not null, primary key
#  sit_id     :integer
#  tag_id     :integer
#  updated_at :datetime         not null
#
# Indexes
#
#  index_taggings_on_sit_id  (sit_id)
#  index_taggings_on_tag_id  (tag_id)
#

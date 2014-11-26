require 'spec_helper'

describe Relationship do
  it { should belong_to(:follower) }
  it { should belong_to(:followed) }

  it { should validate_presence_of(:follower_id) }
  it { should validate_presence_of(:followed_id) }

  it { should respond_to(:followed_id) }
  it { should respond_to(:follower_id) }

end

# == Schema Information
#
# Table name: relationships
#
#  created_at  :datetime
#  followed_id :integer
#  follower_id :integer
#  id          :integer          not null, primary key
#  updated_at  :datetime
#
# Indexes
#
#  index_relationships_on_followed_id                  (followed_id)
#  index_relationships_on_follower_id                  (follower_id)
#  index_relationships_on_follower_id_and_followed_id  (follower_id,followed_id) UNIQUE
#

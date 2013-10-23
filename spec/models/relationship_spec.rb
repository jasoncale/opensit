require 'spec_helper'

describe Relationship do
  it { should belong_to(:follower) }
  it { should belong_to(:followed) }

  it { should validate_presence_of(:follower_id) }
  it { should validate_presence_of(:followed_id) }

  it { should respond_to(:followed_id) }
  it { should respond_to(:follower_id) }

end
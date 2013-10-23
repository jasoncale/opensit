require 'spec_helper'

describe Favourite do
  it { should belong_to(:favourable) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:favourable_id) }
  it { should validate_presence_of(:favourable_type) }

  it { should respond_to(:user_id) }
  it { should respond_to(:favourable_id) }
  it { should respond_to(:favourable_type) }
end

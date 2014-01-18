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

# == Schema Information
#
# Table name: favourites
#
#  created_at      :datetime
#  favourable_id   :integer
#  favourable_type :string(255)
#  id              :integer          not null, primary key
#  updated_at      :datetime
#  user_id         :integer
#
# Indexes
#
#  index_favourites_on_favourable_id  (favourable_id)
#  index_favourites_on_user_id        (user_id)
#

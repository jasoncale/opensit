# == Schema Information
#
# Table name: sits
#
#  id               :integer          not null, primary key
#  title            :string(255)
#  body             :text
#  user_id          :integer
#  disable_comments :boolean
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  duration         :integer
#  s_type           :integer
#  custom_date      :date
#

require 'test_helper'

class SitTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

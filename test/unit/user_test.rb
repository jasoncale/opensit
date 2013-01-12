# == Schema Information
#
# Table name: users
#
#  id                   :integer          not null, primary key
#  username             :string(255)
#  email                :string(255)
#  first_name           :string(255)
#  last_name            :string(255)
#  dob                  :date
#  gender               :integer
#  city                 :string(255)
#  country              :string(255)
#  who                  :text
#  why                  :text
#  style                :string(100)
#  practice             :text
#  private_diary        :boolean
#  default_sit_length   :integer
#  user_type            :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  encrypted_password   :string(128)      default(""), not null
#  password_salt        :string(255)
#  authentication_token :string(255)
#  confirmation_token   :string(255)
#  confirmed_at         :datetime
#  confirmation_sent_at :datetime
#  reset_password_token :string(255)
#  remember_token       :string(255)
#  remember_created_at  :datetime
#  sign_in_count        :integer          default(0)
#  current_sign_in_at   :datetime
#  last_sign_in_at      :datetime
#  current_sign_in_ip   :string(255)
#  last_sign_in_ip      :string(255)
#  failed_attempts      :integer          default(0)
#  unlock_token         :string(255)
#  locked_at            :datetime
#  avatar               :string(255)
#  website              :string(100)
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

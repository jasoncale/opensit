require 'spec_helper'

describe Message do
  it "has a valid factory" do
    expect(build(:message)).to be_valid
  end

end

# == Schema Information
#
# Table name: messages
#
#  body             :text
#  created_at       :datetime         not null
#  from_user_id     :integer
#  id               :integer          not null, primary key
#  read             :boolean          default(FALSE)
#  receiver_deleted :boolean          default(FALSE)
#  sender_deleted   :boolean          default(FALSE)
#  subject          :string(255)
#  to_user_id       :integer
#  updated_at       :datetime         not null
#

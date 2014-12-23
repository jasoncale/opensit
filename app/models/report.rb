class Report < ActiveRecord::Base
  belongs_to :reportable
  belongs_to :user

  validates_presence_of :user_id, :reportable_id, :reportable_type, :reason, :body
  attr_accessible :reportable_id, :reportable_type, :reason, :body
end

# == Schema Information
#
# Table name: reports
#
#  id              :integer          not null, primary key
#  reportable_id   :integer
#  reportable_type :string(255)
#  user_id         :integer
#  reason          :string(255)
#  body            :text
#  created_at      :datetime
#  updated_at      :datetime
#

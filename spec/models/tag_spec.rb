require 'spec_helper'

describe Tag do
  it { should have_many(:taggings) }
  it { should have_many(:sits).through(:taggings) }

  it { should respond_to(:name) }
end

# == Schema Information
#
# Table name: tags
#
#  created_at :datetime         not null
#  id         :integer          not null, primary key
#  name       :string(255)
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Tag do
  it { should have_many(:taggings) }
  it { should have_many(:sits).through(:taggings) }

  it { should respond_to(:name) }
end

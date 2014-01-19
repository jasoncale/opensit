require 'spec_helper'

class ValidatableSpaces
  include ActiveModel::Validations
  attr_accessor :string
  validates :string, no_empty_spaces: true
end

describe NoEmptySpacesValidator do
  let(:validatable) { ValidatableSpaces.new }

  context "when given a string with no spaces" do
    it "is valid" do
      validatable.string = "no_spaces"
      expect(validatable).to be_valid
    end
  end

  context "when given a string with spaces" do
    it "is not valid" do
      validatable.string = "string with spaces"
      expect(validatable).to be_invalid
    end
  end
end

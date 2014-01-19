require 'spec_helper'

class ValidatablePages
  include ActiveModel::Validations
  attr_accessor :name
  validates :name, unique_page_name: true
end

describe UniquePageNameValidator do
  let(:validatable) { ValidatablePages.new }

  context "when given a unique, non-existing page name" do
    it "is valid" do
      validatable.name = "unique_name"
      expect(validatable).to be_valid
    end
  end

  context "when given a pre-existing page name" do
    it "is not valid" do
      validatable.name = "front"
      expect(validatable).to be_invalid
    end
  end

end
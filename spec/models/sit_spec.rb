require 'spec_helper'

describe Sit do
  let(:buddha) { create(:buddha) }
  let(:ananda) { create(:ananda) }

  describe 'creating a user' do
	  it 'sets the streak to 0' do
	    user = create(:user)
	    expect(user.streak).to eq(0)
	  end
	end

	describe "streaks" do
  	context "sat yesterday" do
	  	it "increments streak by 1" do
	  		expect(buddha.streak).to eq 0
	  		create(:sit, user: buddha, created_at: Date.yesterday)
	  		create(:sit, user: buddha, created_at: Date.today)
	  		expect(buddha.reload.streak).to eq 2
	  	end

	  	it "doesn't increment if already sat today" do
        2.times do |i|
          create(:sit, user: buddha, created_at: Date.yesterday - i)
        end
        # Morning sit
        create(:sit, user: buddha, created_at: Date.today + 9.hours)
        expect(buddha.reload.streak).to eq 3
        # Evening sit
	  	  create(:sit, user: buddha, created_at: Date.today + 19.hours)
	  		expect(buddha.reload.streak).to eq 3
	  	end
	  end

	  context "missed a day" do
	  	it "resets streak" do
	  		2.times do |i|
          create(:sit, user: buddha, created_at: Date.yesterday - (i + 1))
        end
	  		create(:sit, user: buddha, created_at: Date.today)
	  		expect(buddha.reload.streak).to eq 0
	  	end
	  end
	end

  context "stubs" do
  	it "should allow sits without bodies" do
  		sit = create(:sit, user: buddha, body: '')
  		expect(sit.valid?).to eq(true)
  	end
  end
end

# == Schema Information
#
# Table name: sits
#
#  body             :text
#  created_at       :datetime
#  disable_comments :boolean
#  duration         :integer
#  id               :integer          not null, primary key
#  private          :boolean          default(FALSE)
#  s_type           :integer
#  title            :string(255)
#  updated_at       :datetime
#  user_id          :integer
#  views            :integer          default(0)
#

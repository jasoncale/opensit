require 'spec_helper'

describe Sit do
  let(:buddha) { create(:buddha) }

	describe "streaks" do
  	context "sat yesterday" do
	  	it "increments streak by 1" do
	  		expect(buddha.streak).to eq 1
	  		last_sit = create(:sit, user: buddha, created_at: Date.yesterday)
	  		todays = create(:sit, user: buddha, created_at: Date.today)
	  		expect(buddha.reload.streak).to eq 2
	  	end
	  end

	  context "missed a day" do
	  	it "resets streak" do
	  		buddha.streak = 16
	  		last_sit = create(:sit, created_at: Date.today - 2)
	  		todays = create(:sit, created_at: Date.today)
	  		expect(buddha.reload.streak).to eq 1
	  	end
	  end
  end
end
require 'spec_helper'
require 'rake'

describe Sit do
  let(:buddha) { create(:buddha) }

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
	  		last_sit = create(:sit, user: buddha, created_at: Date.yesterday)
	  		todays = create(:sit, user: buddha, created_at: Date.today)
	  		expect(buddha.reload.streak).to eq 2
	  	end

	  	it "doesn't increment if already sat today" do
	  		buddha.streak = 7
	  		last_sit = create(:sit, user: buddha, created_at: Date.yesterday)
	  		morning_sit = create(:sit, user: buddha, created_at: Date.today)
	  		expect(buddha.reload.streak).to eq 8
	  		evening_sit = create(:sit, user: buddha, created_at: Date.today)
	  		expect(buddha.reload.streak).to eq 8
	  	end
	  end

	  context "missed a day" do
	  	it "resets streak" do
	  		buddha.streak = 16
	  		last_sit = create(:sit, user: buddha, created_at: Date.today - 2)
	  		todays = create(:sit, user: buddha, created_at: Date.today)
	  		expect(buddha.reload.streak).to eq 0
	  	end
	  end
	end

  # The above only resets a streak if someone posts again, and a day has
  # been missed. This rake task resets streaks nightly.
	describe "rake task" do
		before do
      load File.expand_path("../../../lib/tasks/streaks.rake", __FILE__)
      Rake::Task.define_task(:environment)
    end

	  context "no streak" do
	  	it "resets the streak" do
	  		last_sit = create(:sit, user: buddha, created_at: Date.today - 2)
	  		buddha.streak = 12
	  		buddha.save!
	  		Rake::Task["streak_checker"].invoke
	  		expect(buddha.reload.streak).to eq 0
	  	end
	  end

	  context "streak!" do
	  	it "does nothing if there's a streak in progress" do
	  		last_sit = create(:sit, user: buddha, created_at: Date.yesterday)
	  		buddha.streak = 12
	  		buddha.save!
	  		Rake::Task["streak_checker"].invoke
	  		expect(buddha.reload.streak).to eq 12
	  	end
	  end
  end
end
require 'spec_helper'

describe Goal do
	it 'has valid factory' do
    expect(build(:goal)).to be_valid
  end

  let(:buddha) { create(:buddha) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:goal_type) }

  describe 'new goal' do
		it 'ongoing' do
			buddha.goals.create(goal_type: 0, mins_per_day: 10)
	    expect(buddha.goals.count).to eq(1)
	  end

	  it 'fixed' do
			buddha.goals.create(goal_type: 1, duration: 10)
	    expect(buddha.goals.count).to eq(1)
	  end

	  it 'creates an uncompleted goal' do
			g = buddha.goals.create(goal_type: 1, duration: 10)
	    expect(g.completed?).to eq(false)
	  end
	end

	describe 'goal type' do
	  it '#fixed?' do
	    g = buddha.goals.create(goal_type: 1)
	    expect(g.fixed?).to eq(true)
	  end

	  it '#ongoing?' do
	  	g = buddha.goals.create(goal_type: 0)
	    expect(g.ongoing?).to eq(true)
	  end
	end

	describe "#rating" do
		context 'fixed: sit every day for x days' do
			before :each do
				2.times do |i|
	        create(:sit, user: buddha, created_at: Date.today - i)
	      end
	    end

			it '#rating' do
				# 10 days into goal of sitting every day for 30 days
				# Only sat twice :(
			 	goal = create(:goal, :sit_for_30_days, user: buddha)
	      expect(goal.rating).to eq 20
			end
		end

		context 'fixed: sit 30 minutes a day for 30 days' do
			before :each do
				2.times do |i|
	        create(:sit, user: buddha, created_at: Date.today - i, duration: 30)
	      end
	      # Oops, didn't sit long enough. Go straight to samsara, do not pass go, do not collect £200
	      create(:sit, user: buddha, created_at: Date.today - 3, duration: 20)
	    end

			it '#rating' do
				# 5 days into goal of sitting 30 minutes a day for 30 days
				goal = create(:goal, :sit_30_mins_a_day_for_30_days, user: buddha)
	      expect(goal.rating).to eq 40
			end
		end

		context 'ongoing, with min minutes per day' do
			# Two sits >= 30 mins, and one that won't count
			before :each do
				2.times do |i|
					create(:sit, user: buddha, created_at: Date.today - i, duration: 30)
				end
				create(:sit, user: buddha, created_at: Date.today - 4, duration: 20)
	    end

			it '#rating' do
				# 10 days into goal of sitting every day for 30 days
				goal = create(:goal, :sit_for_30_minutes_a_day, user: buddha)
	      expect(goal.rating).to eq 20
			end
		end
	end

	describe '#rating_colour' do
		let(:goal) { create(:goal, :sit_for_30_days, user: buddha) }

		it 'under 50%' do
			goal.stub(:rating) { 45 }
			expect(goal.rating_colour).to eq 'red'
		end

		it 'under 70%' do
			goal.stub(:rating) { 64 }
			expect(goal.rating_colour).to eq 'amber'
		end

		it 'under 99%' do
			goal.stub(:rating) { 91 }
			expect(goal.rating_colour).to eq 'green'
		end

		it '100%' do
			goal.stub(:rating) { 100 }
			expect(goal.rating_colour).to eq 'gold'
		end
	end

	describe '#last_day_of_goal' do
		let(:goal) { create(:goal, :sit_for_30_days, user: buddha, created_at: Date.today) }
		it 'should return correct day' do
			expect(goal.last_day_of_goal).to eq Date.today + 29 # Only 29 cos today is the first day
		end
	end

	describe '#completed?' do
		context 'fixed' do
			# Started 4 days ago
			let(:goal) { create(:goal, :sit_for_3_days, created_at: Date.today - 4, user: buddha) }

			it 'returns true if goal is completed' do
				expect(goal.completed?).to eq true
			end
		end
	end

	describe '#days_into_goal' do
		context 'fixed' do
			before :each do
				Timecop.return
			end

			let(:goal) { create(:goal, :sit_20_minutes_for_3_days, user: buddha) }

			it 'first day' do
				expect(goal.completed?).to eq false
				expect(goal.days_into_goal).to eq 1
			end

			it 'second day' do
				Timecop.freeze(Date.today + 1)
				expect(goal.completed?).to eq false
				expect(goal.days_into_goal).to eq 2
			end

			it 'third day' do
				Timecop.freeze(Date.today + 2)
				expect(goal.completed?).to eq false
				expect(goal.days_into_goal).to eq 3
			end

			it 'fourth day (goal ended)' do
				Timecop.freeze(Date.today + 3)
				expect(goal.completed?).to eq true
				expect(goal.days_into_goal).to eq 3 # shouldn't increment any further
			end
		end

		context 'ongoing' do
			before :each do
				Timecop.return
			end

			let(:goal) { create(:goal, :sit_for_30_minutes_a_day, user: buddha, created_at: Date.today) }

			it 'first day' do
				expect(goal.completed?).to eq false
				expect(goal.days_into_goal).to eq 1
			end

			it 'fourth day' do
				goal
				Timecop.freeze(Date.today + 3)
				expect(goal.completed?).to eq false
				expect(goal.days_into_goal).to eq 4
			end
		end
	end

	describe '#days_where_goal_met' do
		before :each do
			Timecop.return
		end

		let(:goal) { create(:goal, :sit_for_30_minutes_a_day, user: buddha, created_at: Date.today) }

		it 'increments correctly' do
  		expect(goal.days_where_goal_met).to eq 0
			create(:sit, user: buddha, created_at: Date.today, duration: 30)
  		expect(goal.days_where_goal_met).to eq 1
			Timecop.freeze(Date.today + 1)
			create(:sit, user: buddha, created_at: Date.today, duration: 30)
  		expect(goal.days_where_goal_met).to eq 2
			Timecop.freeze(Date.today + 1)
  		expect(goal.days_where_goal_met).to eq 2 # no change
  	end
	end
end

# == Schema Information
#
# Table name: goals
#
#  completed_date :datetime
#  created_at     :datetime
#  duration       :integer
#  goal_type      :integer
#  id             :integer          not null, primary key
#  mins_per_day   :integer
#  updated_at     :datetime
#  user_id        :integer
#

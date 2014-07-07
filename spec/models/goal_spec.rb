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
		it 'creates a goal for user' do
			buddha.goals.create(goal_type: 1)
	    expect(buddha.goals.count).to eq(1)
	  end

	  it 'creates an uncompleted goal' do
			g = buddha.goals.create(goal_type: 1)
	    expect(g.completed).to eq(false)
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

	describe "goal helpers" do
		context 'fixed: sit every day for x days' do
			# 10 days into goal of sitting every day for 30 days
			let(:goal) { create(:goal, :sit_for_30_days, user: buddha) }

			before :each do
				# Only sat twice :(
				2.times do |i|
	        create(:sit, user: buddha, created_at: Date.today - i)
	      end
	    end

			it '#days_into_goal' do
	      expect(goal.days_into_goal).to eq 10
			end

			it '#days_where_goal_met' do
	      expect(goal.days_where_goal_met).to eq 2
			end

			it '#rating' do
	      expect(goal.rating).to eq 20
			end

			it '#rating_colour' do
				expect(goal.rating_colour).to eq 'red'
			end
		end

		context 'fixed: sit 30 minutes a day for 30 days' do
			# 5 days into goal of sitting 30 minutes a day for 30 days
			let(:goal) { create(:goal, :sit_30_mins_a_day_for_30_days, user: buddha) }

			before :each do
				2.times do |i|
	        create(:sit, user: buddha, created_at: Date.today - i, duration: 30)
	      end
	      # Oops, didn't sit long enough. Go straight to samsara, do not pass go, do not collect £200
	      create(:sit, user: buddha, created_at: Date.today - 3, duration: 20)
	    end

			it '#days_into_goal' do
	      expect(goal.days_into_goal).to eq 5
			end

			it '#days_where_goal_met' do
				expect(buddha.sits.count).to eq 3
	      expect(goal.days_where_goal_met).to eq 2
			end

			it '#rating' do
	      expect(goal.rating).to eq 40
			end

			it '#rating_colour' do
				expect(goal.rating_colour).to eq 'red'
			end
		end

		context 'ongoing, with min minutes per day' do
			# 10 days into goal of sitting every day for 30 days
			let(:goal) { create(:goal, :sit_for_30_minutes_a_day, user: buddha) }

			# Two sits >= 30 mins, and one that won't count
			before :each do
				2.times do |i|
					create(:sit, user: buddha, created_at: Date.today - i, duration: 30)
				end
				create(:sit, user: buddha, created_at: Date.today - 4, duration: 20)
	    end

			it '#days_into_goal' do
	      expect(goal.days_into_goal).to eq 10
			end

			it '#days_where_goal_met' do
				expect(buddha.sits.count).to eq 3
	      expect(goal.days_where_goal_met).to eq 2
			end

			it '#rating' do
	      expect(goal.rating).to eq 20
			end

			it '#rating_colour' do
				expect(goal.rating_colour).to eq 'red'
			end
		end
	end

	describe 'rating' do
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
end

# == Schema Information
#
# Table name: goals
#
#  completed    :boolean          default(FALSE)
#  created_at   :datetime
#  date_ended   :datetime
#  duration     :integer
#  goal_type    :integer
#  id           :integer          not null, primary key
#  mins_per_day :integer
#  updated_at   :datetime
#  user_id      :integer
#

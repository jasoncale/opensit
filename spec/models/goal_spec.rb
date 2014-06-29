require 'spec_helper'

describe Goal do
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
		# 10 days into goal of sitting every day for 30 days
		let(:goal) { buddha.goals.create(goal_type: 1, date_started: Date.today - 9, duration: 30) }
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
	end

	describe 'rating' do
		it 'returns compliance percentage'
		it 'returns gold if 100%'
		it 'returns green if over 80%'
	end
end

# == Schema Information
#
# Table name: goals
#
#  completed       :boolean          default(FALSE)
#  current_day     :integer
#  date_ended      :datetime
#  date_started    :datetime
#  duration        :integer
#  goal_type       :integer
#  id              :integer          not null, primary key
#  successful_days :integer          default(0)
#  user_id         :integer
#

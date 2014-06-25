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
	  it 'fixed?' do
	    g = buddha.goals.create(goal_type: 1)
	    expect(g.fixed?).to eq(true)
	  end

	  it 'ongoing?' do
	  	g = buddha.goals.create(goal_type: 0)
	    expect(g.ongoing?).to eq(true)
	  end
	end

	describe 'successful days' do
		it 'returns how many days the goal has been met'
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

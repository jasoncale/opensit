class AddGoalsTable < ActiveRecord::Migration
  def change
  	create_table(:goals) do |t|
	    t.integer :user_id
	    t.integer :goal_type
			t.integer :duration
			t.integer :mins_per_day
			t.boolean :finished, default: false
			t.datetime :finished_date
			t.timestamps
	  end
  end
end

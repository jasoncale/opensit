class AddStreakToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :streak, :integer, default: '1'
  end
end

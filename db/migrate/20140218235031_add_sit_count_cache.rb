class AddSitCountCache < ActiveRecord::Migration
  def change
  	add_column :users, :sits_count, :integer, default: '0'

  	User.reset_column_information
  	User.all.each do |u|
  		User.reset_counters u.id, :sits
  	end
  end
end

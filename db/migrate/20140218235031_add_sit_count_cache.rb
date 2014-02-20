class AddSitCountCache < ActiveRecord::Migration
  def change
  	 add_column :users, :sits_count, :integer
  end
end

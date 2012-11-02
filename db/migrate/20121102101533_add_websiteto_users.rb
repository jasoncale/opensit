class AddWebsitetoUsers < ActiveRecord::Migration
  def change
  	add_column :users, :website, :string, :limit => 100
  end
end

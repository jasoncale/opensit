class AddViewCounttoSits < ActiveRecord::Migration
  def change
  	 add_column :sits, :views, :integer, :default => 0
  end
end

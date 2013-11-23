class AddPrivateFlagToSits < ActiveRecord::Migration
  def change  	 
    add_column :sits, :private, :boolean, default: false
  end
end

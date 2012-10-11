class AddTypetoSits < ActiveRecord::Migration
  def change
    add_column :sits, :type, :boolean
  end
end

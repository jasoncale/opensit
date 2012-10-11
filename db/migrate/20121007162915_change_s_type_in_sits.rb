class ChangeSTypeInSits < ActiveRecord::Migration
  def change
    remove_column :sits, :s_type
    add_column :sits, :s_type, :integer
  end
end

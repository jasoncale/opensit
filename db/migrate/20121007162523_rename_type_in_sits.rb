class RenameTypeInSits < ActiveRecord::Migration
  def change
    rename_column :sits, :type, :s_type
  end
end

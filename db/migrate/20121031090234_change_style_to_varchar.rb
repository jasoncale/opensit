class ChangeStyleToVarchar < ActiveRecord::Migration
  def change
  	change_column :users, :style, :string, :limit => 100
  end
end

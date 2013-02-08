class ChangeDefaultSitLength < ActiveRecord::Migration
  def change
  	change_column :users, :default_sit_length, :integer, :default => 30
  end
end

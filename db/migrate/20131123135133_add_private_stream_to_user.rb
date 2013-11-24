class AddPrivateStreamToUser < ActiveRecord::Migration
  def change
  	 add_column :users, :private_stream, :boolean, default: false
  end
end

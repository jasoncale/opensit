class CreateFavourites < ActiveRecord::Migration
  def change
    create_table :favourites do |t|
      t.references :favourable, :polymorphic => true
      t.references :user

      t.timestamps
    end
    add_index :favourites, :favourable_id
    add_index :favourites, :user_id
  end
end

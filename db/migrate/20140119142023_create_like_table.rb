class CreateLikeTable < ActiveRecord::Migration
  create_table :likes do |t|
    t.references :likeable, :polymorphic => true
    t.references :user
  end
  add_index :likes, :likeable_id
  add_index :likes, :user_id
end

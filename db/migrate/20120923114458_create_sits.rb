class CreateSits < ActiveRecord::Migration
  def change
    create_table :sits do |t|
      t.string :title
      t.text :body
      t.integer :user_id
      t.boolean :allow_comments

      t.timestamps
    end
  end
end

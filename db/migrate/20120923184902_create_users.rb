class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password
      t.timestamp :last_login
      t.string :profile_pic
      t.string :first_name
      t.string :last_name
      t.date :dob
      t.integer :gender
      t.string :city
      t.string :country
      t.text :who
      t.text :why
      t.text :style
      t.text :practice
      t.boolean :public_diary
      t.integer :default_sit_length
      t.integer :user_type

      t.timestamps
    end
  end
end

class CreateReports < ActiveRecord::Migration
  create_table :reports do |t|
    t.references :reportable, :polymorphic => true
    t.references :user
    t.string :reason
    t.text :body

    t.timestamps
  end
  add_index :reports, :reportable_id
  add_index :reports, :user_id
end

class AddAttachmentDrawingToSits < ActiveRecord::Migration
  def self.up
    change_table :sits do |t|
      t.attachment :drawing
    end
  end

  def self.down
    remove_attachment :sits, :drawing
  end
end

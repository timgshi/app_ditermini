class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :notifier_id
      t.integer :notified_id
      t.string :message

      t.timestamps
    end

    add_index :notifications, :notifier_id
    add_index :notifications, :notified_id
  end
end

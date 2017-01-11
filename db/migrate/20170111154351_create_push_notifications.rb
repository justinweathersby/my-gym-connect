class CreatePushNotifications < ActiveRecord::Migration
  def change
    create_table :push_notifications do |t|
      t.string :message
      t.string :tokens
      t.string :sent_to
      t.string :user_id

      t.belongs_to :gym, index: true
      t.timestamps
    end
  end
end

class RebuildMessages < ActiveRecord::Migration
  def up
    drop_table :messages
    create_table :conversations do |t|
     t.integer :sender_id
     t.integer :recipient_id

     t.timestamps
    end
    create_table :messages do |t|
      t.text :body
      t.references :conversation, index: true
      t.references :user, index: true
      t.boolean :read, :default => false

      t.timestamps
    end
  end
  def down
    drop_table :messages
    create_table :messages do |t|
      t.integer :user_id, index: true
      t.integer :sender_id, index: true
      t.text :body
      t.timestamps null: false
    end
  end
end

class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :user_id, index: true
      t.integer :sender_id, index: true
      t.text :body
      t.timestamps null: false
    end
  end
end

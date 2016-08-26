class CreateGyms < ActiveRecord::Migration
  def change
    create_table :gyms do |t|
      t.string :name
      t.string :contact_email
      t.string :phone
      t.string :location
      t.belongs_to :user, index: true
      t.timestamps null: false
    end
  end
end

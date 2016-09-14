class AddGymCodeToGyms < ActiveRecord::Migration
  def change
    add_column :gyms, :access_code, :string
    add_index :gyms, :access_code
  end
end

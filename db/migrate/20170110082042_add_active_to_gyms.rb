class AddActiveToGyms < ActiveRecord::Migration
  def change
    add_column :gyms, :active, :boolean, :default => false
    add_column :gyms, :subscription_id, :string
  end
end

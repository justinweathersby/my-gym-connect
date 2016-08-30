class AddHoursOfOperationToGyms < ActiveRecord::Migration
  def change
    add_column :gyms, :hours_of_operation, :text
  end
end

class AddHourInGymToUsers < ActiveRecord::Migration
  def change
    add_column :users, :hours_in_gym, :text
  end
end

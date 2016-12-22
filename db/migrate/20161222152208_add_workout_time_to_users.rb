class AddWorkoutTimeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :workout_time, :string
  end
end

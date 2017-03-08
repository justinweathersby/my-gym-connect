class AddMoreCategoriesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :days_per_week, :integer
    add_column :users, :cardio_per_week, :integer
    add_column :users, :workout_preference, :string
    add_column :users, :attend_classes, :string
  end
end

class ChangeCardioPerWeekToString < ActiveRecord::Migration
  def up
    change_column :users, :cardio_per_week, :string
  end

  def down
    change_column :users, :cardio_per_week, :integer
  end
end

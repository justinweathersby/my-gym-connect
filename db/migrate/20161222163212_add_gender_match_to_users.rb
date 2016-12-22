class AddGenderMatchToUsers < ActiveRecord::Migration
  def change
    add_column :users, :gender_match, :string
  end
end

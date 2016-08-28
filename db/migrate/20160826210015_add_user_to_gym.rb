class AddUserToGym < ActiveRecord::Migration
  def change
    add_reference :users, :gym, index: true, foreign_key: true
  end
end

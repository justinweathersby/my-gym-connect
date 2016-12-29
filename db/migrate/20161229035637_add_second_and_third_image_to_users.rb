class AddSecondAndThirdImageToUsers < ActiveRecord::Migration
  def self.up
    add_attachment :users, :second_image
    add_attachment :users, :third_image
  end
  def self.down
    remove_attachment :users, :second_image
    remove_attachment :users, :third_image
  end
end

class AddImageToGyms < ActiveRecord::Migration
  def self.up
    add_attachment :gyms, :image
  end

  def self.down
    remove_attachment :gyms, :image
  end
end

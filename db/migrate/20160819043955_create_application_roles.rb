class CreateApplicationRoles < ActiveRecord::Migration
  def up
    ['admin', 'gymManager', 'banned'].each do |role_name|
      Role.create! name: role_name
    end
  end
  def down
    Role.where(name: ['admin', 'gymManager', 'banned']).destroy_all
  end
end

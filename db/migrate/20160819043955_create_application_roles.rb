class CreateApplicationRoles < ActiveRecord::Migration
  def up
    ['admin', 'gym-manager'].each do |role_name|
      Role.create! name: role_name
    end
    user = User.find_by_email("admin@admin.com")
    user.add_role :admin
  end
  def down
    Role.where(name: ['admin', 'gym-manager']).destroy_all
  end
end

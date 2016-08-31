ActiveAdmin.register Gym do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

permit_params :name, :contact_email, :location, :phone, :hours_of_operation, :user_id,
              :image, :remove_image

  index do
      column :name
      column :contact_email
      column :created_at
      actions
  end

  show do
    attributes_table do
      row :name
      row :contact_email
      row :location
      row :phone
      row :hours_of_operation
      row "Ownership Id: ", :user_id
      row "Image" do |image|
        "<img src='#{image.image.url(:thumb)}', alt='NA'".html_safe
      end
    end
  end

  filter :name
  filter :user_id

  form do |f|
      f.inputs "Gym Details" do
          f.input :name
          f.input :contact_email
          f.input :location
          f.input :phone
          f.input :hours_of_operation
          f.input :image, :as => :file, :hint => f.object.image.present? ? image_tag(f.object.image.url(:thumb)) : ""
          if f.object.image?
            f.input :remove_image, as: :boolean, required: false, label: "Remove Image"
          end
          f.input :user_id,
             :label       => 'User that owns gym: (Be careful changing this it doesnt update who pays yet this would just be for login purposes)',
             :as          => :select,
             :collection  => User.all.map{|u| ["#{u.email}", u.id]}

      end
      f.actions
  end
end

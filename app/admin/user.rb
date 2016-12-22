ActiveAdmin.register User do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

permit_params :email, :name, :password, :password_confirmation,
              :role, :gender, :gender_match,
              :image, :remove_image,
              :workout_level, :workout_time, :gym_id

  index do
      column :email
      column :current_sign_in_at
      column :last_sign_in_at
      column :sign_in_count
      column :role
      actions
  end

  show do
    attributes_table do
      row :email
      row :created_at
      row :last_sign_in_at
      row :name
      row :role
      row :gender
      row :gender_match
      row "Image" do |image|
        "<img src='#{image.image.url(:thumb)}', alt='NA'".html_safe
      end
      row :workout_level
      row :workout_time
      row :gym_id do |g|
        Gym.find(g.gym_id) if g.gym_id.present?
      end
    end
  end

  filter :email
  filter :gym_id
  filter :workout_level
  filter :workout_time
  filter :role
  filter :created_at

  form do |f|
      f.inputs "User Details" do
          f.input :email
          f.input :name
          f.input :role,
                  :as => :select,
                  :collection => {None: "", GymManager: "gymManager", Administrator: "admin"}
          f.input :gender,
                  :as => :select,
                  :collection => User::GENDERS
          f.input :gender_match,
                  :as => :select,
                  :collection => User::GENDERMATCH
          f.input :workout_level,
             :label      => 'Workout Level',
             :as         => :select,
             :collection => User::WORKOUTLEVELS
          f.input :workout_time,
             :label      => 'Workout Time',
             :as         => :select,
             :collection => User::WORKOUTTIMES
          # f.input :hours_in_gym,
          #    :label      => 'Hour Blocks (Hold control or command button and click the blocks)',
          #    :as         => :select,
          #    :multiple   => :true,
          #    :collection => (0..167)
          f.input :gym_id,
             :label       => 'Associated Gym',
             :as          => :select,
             :collection  => Gym.all.sort_by{|gym| gym.name}
         f.input :image, :as => :file, :hint => f.object.image.present? ? image_tag(f.object.image.url(:thumb)) : ""
         if f.object.image?
           f.input :remove_image, as: :boolean, required: false, label: "Remove Image"
         end

      end
      f.actions
  end
end

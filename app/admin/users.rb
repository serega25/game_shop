ActiveAdmin.register User do
  # Filters for attributes and associations
  filter :email
  filter :created_at
  filter :profile_nickname, as: :string
  filter :profile_full_name, as: :string
  filter :orders

  # Customize index, show, form, etc. if needed
  index do
    selectable_column
    id_column
    column :email
    column :created_at
    column "Profile Nickname", sortable: 'profiles.nickname' do |user|
      user.profile&.nickname
    end
    column "Profile Full Name", sortable: 'profiles.full_name' do |user|
      user.profile&.full_name
    end
    actions
  end

  # Permitting parameters for strong parameters
  permit_params :email, :password, :password_confirmation, profile_attributes: [:nickname, :full_name]

  # Optional: Customize form for nested attributes
  form do |f|
    f.inputs "User Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end

    f.inputs "Profile" do
      f.semantic_fields_for :profile, (f.object.profile || f.object.build_profile) do |p|
        p.input :nickname
        p.input :full_name
      end
    end

    f.actions
  end

end

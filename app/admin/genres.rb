ActiveAdmin.register Genre do
  permit_params :name

  filter :name
  filter :created_at
  filter :updated_at
  filter :games_name_cont, as: :string, label: 'Game Name'

  index do
    selectable_column
    id_column
    column :name
    column :games
    column :created_at
    column :updated_at
    actions
  end
end

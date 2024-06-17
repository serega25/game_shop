ActiveAdmin.register Game do
  # Permitting parameters for strong parameters
  permit_params :name, :developer, :distributor, :genre, :order_id, :description, :id_value, :platforms, :price_for_one, :cover, pictures: []

  # Customize the form for nested attributes
  form do |f|
    f.inputs "Game Details" do
      f.input :name
      f.input :developer
      f.input :distributor
      f.input :genre
      f.input :order
      f.input :description
      f.input :id_value
      f.input :platforms
      f.input :price_for_one
      f.input :cover, as: :file
      f.input :pictures, as: :file, input_html: { multiple: true }
    end
    f.actions
  end

  # Customize index view
  index do
    selectable_column
    id_column
    column :name
    column :developer
    column :distributor
    column :genre
    column :order
    column :description
    column :id_value
    column :platforms
    column :price_for_one
    column "Cover" do |game|
      if game.cover.attached?
        image_tag url_for(game.cover), size: "50x50"
      end
    end
    actions
  end

  # Customize show view
  show do |game|
    attributes_table do
      row :name
      row :developer
      row :distributor
      row :genre
      row :order
      row :description
      row :id_value
      row :platforms
      row :price_for_one
      row "Cover" do |game|
        if game.cover.attached?
          image_tag url_for(game.cover)
        end
      end
      row "Pictures" do |game|
        if game.pictures.attached?
          game.pictures.each do |pic|
            div do
              image_tag url_for(pic), size: "100x100"
            end
          end
        end
      end
    end
  end

  # Custom filters
  filter :name
  filter :developer
  filter :distributor
  filter :genre
  filter :order
  filter :with_cover, as: :boolean, label: 'Has Cover'
  filter :without_cover, as: :boolean, label: 'No Cover'
end

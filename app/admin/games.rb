ActiveAdmin.register Game do
  permit_params :name, :description, :platforms, :distributor, :developer, :price_for_one, :cover, pictures: [], genre_ids: []

  form do |f|
    f.inputs "Game Details" do
      f.input :name
      f.input :description
      f.input :platforms
      f.input :distributor
      f.input :developer
      f.input :price_for_one
    end

    f.inputs "Genres" do
      f.input :genres, as: :check_boxes, collection: Genre.all
    end

    f.inputs "Attachments" do
      f.input :cover, as: :file
      f.input :pictures, as: :file, input_html: { multiple: true }
    end

    f.actions
  end

  index do
    selectable_column
    id_column
    column :name
    column :description
    column :platforms
    column :distributor
    column :developer
    column "Genres" do |game|
      game.genres.map(&:name).join(', ')
    end
    column :price_for_one
    actions
  end

  show do
    attributes_table do
      row :name
      row :description
      row :platforms
      row :distributor
      row :developer
      row :price_for_one
      row :genres
      row :cover do |game|
        if game.cover.attached?
          image_tag url_for(game.cover), size: "100x100"
        end
      end
      row :pictures do |game|
        if game.pictures.attached?
          game.pictures.map do |picture|
            image_tag url_for(picture), size: "100x100"
          end.join(' ').html_safe
        end
      end
    end
  end

  controller do
    def create
      if params[:game][:genre_ids].present?
        params[:game][:genre_ids] = params[:game][:genre_ids].reject(&:blank?)
      end
      super
    end

    def update
      if params[:game][:genre_ids].present?
        params[:game][:genre_ids] = params[:game][:genre_ids].reject(&:blank?)
      end
      super
    end
  end

  # Disabling filters for this resource
  config.filters = false
end

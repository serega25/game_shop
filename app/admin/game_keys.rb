ActiveAdmin.register GameKey do
  permit_params :game_id, :key

  form partial: 'form'

  action_item :upload, only: :index do
    link_to 'Upload Game Keys', action: 'upload_keys'
  end

  collection_action :upload_keys do
    render 'admin/upload_keys'
  end

  collection_action :import_keys, method: :post do
    uploaded_file = params[:game_key][:json_file].tempfile
    json_data = JSON.parse(File.read(uploaded_file))

    json_data.each do |game_data|
      game_id = game_data["game_id"]
      keys = game_data["keys"]

      keys.each do |key|
        GameKey.create(game_id: game_id, key: key)
      end
    end

     redirect_to admin_game_keys_path, notice: "Game keys uploaded successfully."
  rescue JSON::ParserError => e
     redirect_to admin_game_keys_path, alert: "Invalid JSON format. Please upload a valid JSON file."
  end

  form do |f|
    f.inputs "Game Key Details" do
      f.input :game
      f.input :key
    end
    f.actions
  end
end

ActiveAdmin.register Order do
  # Permitting only attributes needed for viewing orders
  permit_params :user_id, :total_price, :status

  # Disabling creation, editing, and deletion of orders
  actions :index, :show

  # Disabling filters for this resource
  config.filters = false

  index do
    selectable_column
    id_column
    column :user
    column :total_price
    column :status
    actions
  end

  show do |order|
    attributes_table do
      row :user
      row :total_price
      row :status
      row :created_at
      row :updated_at
      row :stripe_payment_intent_id
    end

    panel "Order Items" do
      table_for order.order_items do
        column :game
        column :quantity
        column :price
      end
    end
  end
end

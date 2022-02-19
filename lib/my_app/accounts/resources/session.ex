defmodule MyApp.Accounts.Session do
  use Ash.Resource, data_layer: Ash.DataLayer.Ets

  attributes do
    uuid_primary_key(:id)
    attribute(:value, :map, default: %{})
    create_timestamp(:created_date)
    update_timestamp(:updated_date)
  end

  relationships do
    has_many :toasts, MyApp.Accounts.Toast do
      destination_field(:session_id)
      sort(created_date: :asc)
    end
  end
end

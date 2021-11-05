defmodule MyApp.Accounts.Toast do
  use Ash.Resource, data_layer: Ash.DataLayer.Ets

  attributes do
    uuid_primary_key(:id)
    attribute(:message, :string, allow_nil?: false)
    attribute(:type, :atom, allow_nil?: false)
    create_timestamp(:created_date)
  end

  relationships do
    belongs_to :session, MyApp.Accounts.Session, required?: true
  end

  actions do
    create :primary_create do
      primary?(true)
    end

    create :create do
      argument(:session_id, :uuid, allow_nil?: false)
      change(manage_relationship(:session_id, :session, type: :replace))
    end

    read :read do
      primary?(true)
    end

    read :for_session do
      argument(:session_id, :uuid, allow_nil?: false)

      prepare(
        build(
          sort: [created_date: :asc],
          limit: 3
        )
      )

      filter(expr(session_id == ^arg(:session_id)))
    end
  end
end

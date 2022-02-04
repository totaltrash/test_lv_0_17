defmodule MyApp.Calendar.Event do
  use Ash.Resource, data_layer: AshPostgres.DataLayer

  postgres do
    table("calendar_event")
    repo(MyApp.Repo)
  end

  attributes do
    uuid_primary_key :id

    attribute :title, :string do
      allow_nil?(false)
    end

    attribute :start_on, :utc_datetime do
      allow_nil?(false)
    end

    create_timestamp :created_date
    update_timestamp :updated_date
  end

  # actions do
  #   create :primary_create do
  #     primary?(true)
  #   end

  #   read :read do
  #     primary?(true)
  #   end
  # end
end

defmodule MyApp.Blog.Post do
  use Ash.Resource, data_layer: AshPostgres.DataLayer

  postgres do
    table("blog_post")
    repo(MyApp.Repo)
  end

  attributes do
    uuid_primary_key :id

    attribute :title, :string do
      allow_nil?(false)
    end

    create_timestamp :created_date
    update_timestamp :updated_date
  end

  relationships do
    many_to_many :tags, MyApp.Blog.Tag do
      through MyApp.Blog.PostTag
      source_field_on_join_table :post_id
      destination_field_on_join_table :tag_id
      sort title: :asc
    end
  end

  actions do
    read :read do
      primary?(true)
      prepare(build(sort: [updated_date: :desc], load: [:tags]))
    end

    read :resource_loader do
      pagination(offset?: true, countable: true)
      prepare(build(sort: [updated_date: :desc], load: [:tags]))
    end

    create :primary_create do
      primary?(true)
    end

    create :create do
      argument(:tags, {:array, :uuid})
      change manage_relationship(:tags, type: :replace)
    end
  end
end

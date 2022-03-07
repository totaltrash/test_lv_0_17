defmodule MyApp.Blog.Tag do
  use Ash.Resource, data_layer: AshPostgres.DataLayer

  postgres do
    table("blog_tag")
    repo(MyApp.Repo)
  end

  attributes do
    uuid_primary_key(:id)

    attribute :title, :string do
      allow_nil?(false)
      constraints(max_length: 100)
    end

    create_timestamp(:created_date)
    update_timestamp(:updated_date)
  end

  # actions do
  #   read :read do
  #     primary?(true)
  #     prepare(build(sort: [code: :asc]))
  #   end

  #   create :create do
  #     primary?(true)
  #     change {UpperCase, [attribute: :code]}
  #   end

  #   update :update do
  #     primary?(true)
  #     change {UpperCase, [attribute: :code]}
  #   end
  # end

  identities do
    identity :unique_title, [:title], message: "Tag title already exists"
  end
end

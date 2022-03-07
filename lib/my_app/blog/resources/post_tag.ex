defmodule MyApp.Blog.PostTag do
  use Ash.Resource, data_layer: AshPostgres.DataLayer

  postgres do
    table "blog_post_tag"
    repo MyApp.Repo
  end

  attributes do
    create_timestamp :created_date
  end

  relationships do
    belongs_to :post, MyApp.Blog.Post, primary_key?: true, required?: true
    belongs_to :tag, MyApp.Blog.Tag, primary_key?: true, required?: true
  end
end

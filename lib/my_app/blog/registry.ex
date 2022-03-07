defmodule MyApp.Blog.Registry do
  use Ash.Registry,
    extensions: [Ash.Registry.ResourceValidations]

  entries do
    entry MyApp.Blog.Post
    entry MyApp.Blog.Tag
    entry MyApp.Blog.PostTag
  end
end

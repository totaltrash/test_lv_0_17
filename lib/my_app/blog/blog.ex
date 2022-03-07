defmodule MyApp.Blog do
  use Ash.Api

  resources do
    registry(MyApp.Blog.Registry)
  end
end

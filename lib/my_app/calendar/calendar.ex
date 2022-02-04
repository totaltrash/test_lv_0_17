defmodule MyApp.Calendar do
  use Ash.Api

  resources do
    registry(MyApp.Calendar.Registry)
  end
end

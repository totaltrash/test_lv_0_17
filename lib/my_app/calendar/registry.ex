defmodule MyApp.Calendar.Registry do
  use Ash.Registry,
    extensions: [Ash.Registry.ResourceValidations]

  entries do
    entry(MyApp.Calendar.Event)
  end
end

defmodule MyApp.Accounts.Registry do
  use Ash.Registry,
    extensions: [Ash.Registry.ResourceValidations]

  entries do
    entry(MyApp.Accounts.Session)
    entry(MyApp.Accounts.Toast)
  end
end

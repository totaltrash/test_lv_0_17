defmodule MyApp.Accounts do
  use Ash.Api

  resources do
    registry(MyApp.Accounts.Registry)
  end
end

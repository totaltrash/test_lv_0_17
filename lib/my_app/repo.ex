defmodule MyApp.Repo do
  use AshPostgres.Repo,
    otp_app: :my_app

  def installed_extensions() do
    ["uuid-ossp", "pg_trgm", "citext"]
  end
end

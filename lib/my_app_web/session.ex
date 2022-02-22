defmodule MyAppWeb.Session do
  @api MyApp.Accounts
  @resource MyApp.Accounts.Session

  def get(session_id) do
    case get_session_resource(session_id) do
      nil -> %{}
      session -> session.value
    end
  end

  def get(session_id, key, default \\ nil) do
    # IO.puts("Session get called with #{key}")

    case get_session_resource(session_id) do
      nil -> default
      session -> Map.get(session.value, key, default)
    end
  end

  def set(session_id, key, value) do
    # IO.puts("Session set called with #{key}: #{inspect(value)}")

    session =
      case get_session_resource(session_id) do
        nil ->
          @resource
          |> Ash.Changeset.for_create(:create, %{session_id: session_id})
          |> @api.create!()

        session ->
          session
      end

    session
    |> Ash.Changeset.for_update(:update, %{value: Map.put(session.value, key, value)})
    |> @api.update!()

    # what to return ? the session_id for chaining???
    session_id
  end

  defp get_session_resource(session_id) do
    @api.get(@resource, session_id)
    |> case do
      {:ok, session} -> session
      _ -> nil
    end
  end
end

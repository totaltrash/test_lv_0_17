defmodule MyAppWeb.InitAssigns do
  import Phoenix.LiveView

  def on_mount(:default, _params, session, socket) do
    session_id = Map.get(session, "session_id")

    socket =
      socket
      |> assign(:session_id, session_id)
      |> assign(:toasts, get_toasts(session_id))
      |> attach_hook(:reload_toasts, :handle_info, &reload_toasts/2)
      |> attach_hook(:clear_toast, :handle_event, &clear_toast/3)

    {:cont, socket}
  end

  defp reload_toasts({:reload_toasts}, socket) do
    # IO.puts("RELOAD TOASTS")
    {:halt, assign(socket, :toasts, get_toasts(socket.assigns.session_id))}
  end

  defp reload_toasts(_, socket), do: {:cont, socket}

  defp clear_toast("clear_toast", %{"id" => id}, socket) do
    # IO.inspect("CLEAR TOAST #{id}")

    case MyApp.Accounts.get(MyApp.Accounts.Toast, id) do
      {:ok, toast} ->
        toast
        |> Ash.Changeset.for_destroy(:destroy)
        |> MyApp.Accounts.destroy!()

      _ ->
        nil
    end

    {:halt, assign(socket, :toasts, get_toasts(socket.assigns.session_id))}
  end

  defp clear_toast(_, _, socket), do: {:cont, socket}

  defp get_toasts(session_id) do
    MyApp.Accounts.Toast
    |> Ash.Query.for_read(:for_session, %{session_id: session_id})
    |> MyApp.Accounts.read!()
  end
end

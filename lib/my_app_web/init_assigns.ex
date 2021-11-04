defmodule MyAppWeb.InitAssigns do
  import Phoenix.LiveView

  def on_mount(:default, _params, _session, socket) do
    socket =
      socket
      |> assign(:toasts, [])
      |> attach_hook(:add_toast, :handle_info, &add_toast/2)
      |> attach_hook(:clear_toast, :handle_event, &clear_toast/3)

    {:cont, socket}
  end

  defp add_toast({:add_toast, toast}, socket) do
    toast = Map.put(toast, :id, System.unique_integer([:positive]))

    {:halt, update(socket, :toasts, &[toast | &1])}
  end

  defp add_toast(_, socket), do: {:cont, socket}

  defp clear_toast("clear_toast", %{"id" => id} = params, socket) do
    {:halt,
     update(socket, :toasts, fn toasts ->
       Enum.reject(toasts, fn toast -> toast.id == String.to_integer(id) end)
     end)}
  end

  defp clear_toast(_, _, socket), do: {:cont, socket}
end

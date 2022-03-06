defmodule IFixComponents.Toast do
  use Phoenix.Component
  alias Phoenix.LiveView.JS
  import Heroicons.LiveView

  def toaster(assigns) do
    ~H"""
    <%= if Phoenix.LiveView.connected?(@socket) do %>
      <div class="z-50 fixed bottom-0 left-0 w-full md:w-96 mt-10 px-4 md:px-6 pb-3 flex flex-col gap-3">
        <%= for toast <- @toasts do %>
          <.toast toast={toast}></.toast>
        <% end %>
      </div>
    <% end %>
    """
  end

  defp toast(assigns) do
    ~H"""
    <div
      id={"toast-#{to_string(@toast.id)}"}
      class={"fade-in #{get_color(@toast.type)} font-medium border-l-8 border-r-2 bg-white py-2 px-3 shadow-xl flex justify-between items-center"}
      data-timeout={get_timeout(@toast.type)}
      data-id={@toast.id}
      role="alert"
      phx-hook="Toast"
      phx-remove={JS.hide(to: "#toast-#{to_string(@toast.id)}", transition: "fade-out", time: 200)}
    >
      <div class="flex items-center gap-2">
        <.icon name={get_icon(@toast.type)} type="solid" class="h-6 w-6" />
        <%= @toast.message %>
      </div>
      <button class="focus:outline-none hover:bg-gray-100 p-1"
        type="button"
        aria-label="Dismiss"
        phx-click="clear_toast"
        phx-value-id={@toast.id}
      >
        <.icon name="x" type="solid" class="h-4 w-4" />
      </button>
    </div>
    """
  end

  defp get_color(:error), do: "text-red-600 border-red-600"
  defp get_color(:success), do: "text-green-600 border-green-600"
  defp get_color(_), do: "text-blue-600 border-blue-600"

  defp get_icon(:error), do: "exclamation"
  defp get_icon(:success), do: "check-circle"
  defp get_icon(_), do: "exclamation-circle"

  defp get_timeout(:error), do: 6000
  defp get_timeout(_), do: 3000
end

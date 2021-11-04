defmodule MyAppWeb.Toast do
  use Phoenix.Component
  alias Phoenix.LiveView.JS

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
      <div>
        <%= @toast.message %>
      </div>
      <button class="focus:outline-none"
        type="button"
        aria-label="Dismiss"
        phx-click="clear_toast"
        phx-value-id={@toast.id}
      >
        <svg class="fill-current"
          width="16"
          height="16"
          viewBox="0 0 32 32"
        >
          <path d="M6.869 6.869c0.625-0.625 1.638-0.625 2.263 0l6.869 6.869 6.869-6.869c0.625-0.625 1.638-0.625 2.263 0s0.625 1.638 0 2.263l-6.869 6.869 6.869 6.869c0.625 0.625 0.625 1.638 0 2.263s-1.638 0.625-2.263 0l-6.869-6.869-6.869 6.869c-0.625 0.625-1.638 0.625-2.263 0s-0.625-1.638 0-2.263l6.869-6.869-6.869-6.869c-0.625-0.625-0.625-1.638 0-2.263z"></path>
        </svg>
      </button>
    </div>
    """
  end

  defp get_color("error"), do: "text-red-600 border-red-600"
  defp get_color("success"), do: "text-green-600 border-green-600"
  defp get_color(_), do: "text-blue-600 border-blue-600"

  defp get_timeout("error"), do: 9000
  defp get_timeout(_), do: 3000
end

defmodule IFixComponents.ToastFlash do
  use Phoenix.Component
  import Heroicons.LiveView
  alias Phoenix.LiveView.JS

  def toaster(assigns) do
    ~H"""
    <%= if Phoenix.LiveView.connected?(@socket) do %>
      <div class="z-50 fixed bottom-0 right-0 w-full md:w-96 mt-10 px-4 md:px-6 pb-3 flex flex-col gap-3">
        <.toast type={:error} color="bg-red-600" timeout={9000} flash={@flash}></.toast>
        <.toast type={:success} color="bg-green-600" timeout={3000} flash={@flash}></.toast>
        <.toast type={:info} color="bg-blue-600" timeout={3000} flash={@flash}></.toast>
      </div>
    <% end %>
    """
  end

  def toast(assigns) do
    ~H"""
    <%= if !!live_flash(@flash, @type) do %>
      <div
        id={"flash-#{to_string(@type)}"}
        class={"fade-in #{@color} text-white py-2 md:py-3 px-3 rounded-md md:rounded-md alert shadow-xl flex justify-between items-center"}
        data-timeout={@timeout}
        data-key={@type}
        role="alert"
        phx-hook="Flash"
        phx-remove={JS.hide(to: "#flash-#{to_string(@type)}", transition: "fade-out", time: 200)}
      >
        <div>
          <%= live_flash(@flash, @type) %>
        </div>
        <button class="focus:outline-none"
          type="button"
          aria-label="Dismiss"
          phx-click="lv:clear-flash"
          phx-value-key={@type}
        >
          <.icon name="x" type="solid" class="h-4 w-4" />
        </button>
      </div>
    <% end %>
    """
  end
end

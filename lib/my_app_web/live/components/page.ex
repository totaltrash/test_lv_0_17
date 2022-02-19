defmodule MyAppWeb.Page do
  use Phoenix.Component
  import Heroicons.LiveView
  alias MyAppWeb.Router.Helpers, as: Routes
  alias Phoenix.LiveView.JS

  def h1(assigns) do
    assigns = assign_new(assigns, :label, fn -> nil end)

    ~H"""
    <h1 class="text-2xl font-medium mb-2"><%= @label || render_slot(@inner_block) %></h1>
    """
  end

  def h2(assigns) do
    assigns = assign_new(assigns, :label, fn -> nil end)

    ~H"""
    <h2 class="text-lg font-medium text-gray-500 mb-2"><%= @label || render_slot(@inner_block) %></h2>
    """
  end

  def components_container(assigns) do
    ~H"""
    <div class="flex flex-wrap items-center gap-4 mb-8">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  def format_datetime(assigns) do
    ~H[<%= Timex.Timezone.convert(@datetime, "Australia/Melbourne") |> Calendar.strftime("%d/%m/%Y %H:%M:%S") %>]
  end

  defp menu_items do
    [
      %{id: "home", label: "Home", path: Routes.home_path(MyAppWeb.Endpoint, :index)},
      %{
        id: "components",
        label: "Components",
        path: Routes.components_path(MyAppWeb.Endpoint, :index)
      },
      %{
        id: "resource_data_tables",
        label: "Resource Data Tables",
        path: Routes.resource_data_tables_path(MyAppWeb.Endpoint, :index)
      },
      %{
        id: "temporary_assigns",
        label: "Temp Assigns",
        path: Routes.temporary_assigns_path(MyAppWeb.Endpoint, :index)
      },
      %{
        id: "timestamps",
        label: "Timestamps",
        path: Routes.timestamps_path(MyAppWeb.Endpoint, :index)
      },
      %{
        id: "uploads",
        label: "Uploads",
        path: Routes.uploads_path(MyAppWeb.Endpoint, :index)
      }
    ]
  end

  def wrapper(assigns) do
    ~H"""
    <div
      class="min-h-full"
      phx-remove={on_remove()}
    >
      <nav class="bg-gray-800">
        <div class="px-4 sm:px-6 lg:px-8">
          <div class="flex items-center justify-between h-16">
            <div class="flex items-center">
              <div class="flex-shrink-0">
                <img class="h-8 w-8" src="https://tailwindui.com/img/logos/workflow-mark-indigo-500.svg" alt="Workflow">
              </div>
              <div class="hidden md:block">
                <div class="ml-10 flex items-baseline space-x-4">
                  <!-- Current: "bg-gray-900 text-white", Default: "text-gray-300 hover:bg-gray-700 hover:text-white" -->
                  <%= for menu_item <- menu_items() do %>
                    <%= live_redirect(menu_item.label, to: menu_item.path, class: get_item_class(menu_item, @current_menu)) %>
                  <% end %>
                </div>
              </div>
            </div>
            <div class="hidden md:block">
              <div class="ml-4 flex items-center md:ml-6">
                <button type="button" class="bg-gray-800 p-1 rounded-full text-gray-400 hover:text-white focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-offset-gray-800 focus:ring-white">
                  <span class="sr-only">View notifications</span>
                  <.icon name="bell" type="outline" class="h-6 w-6" />
                </button>

                <!-- Profile dropdown -->
                <div class="ml-3 relative">
                  <div>
                    <button
                      phx-click={toggle_profile_menu()}
                      type="button"
                      class="max-w-xs bg-gray-800 rounded-full flex items-center text-sm focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-offset-gray-800 focus:ring-white"
                      id="user-menu-button"
                      aria-expanded="false"
                      aria-haspopup="true"
                    >
                      <span class="sr-only">Open user menu</span>
                      <img class="h-8 w-8 rounded-full" src="https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80" alt="">
                    </button>
                  </div>

                  <!--
                    Dropdown menu, show/hide based on menu state.

                    Entering: "transition ease-out duration-100"
                      From: "opacity-0 scale-95"
                      To: "opacity-100 scale-100"
                    Leaving: "transition ease-in duration-75"
                      From: "opacity-100 scale-100"
                      To: "opacity-0 scale-95"
                  -->
                  <div
                    phx-remove={hide_profile_menu()}
                    phx-click-away={hide_profile_menu()}
                    phx-window-keydown={hide_profile_menu()}
                    phx-key="escape"
                    id="profile-menu"
                    class="hidden origin-top-right absolute right-0 mt-2 w-48 rounded-md shadow-lg py-1 bg-white ring-1 ring-black ring-opacity-5 focus:outline-none"
                    role="menu"
                    aria-orientation="vertical"
                    aria-labelledby="user-menu-button"
                    tabindex="-1"
                  >
                    <!-- Active: "bg-gray-100", Not Active: "" -->
                    <a href="#" class="block px-4 py-2 text-sm text-gray-700" role="menuitem" tabindex="-1" id="user-menu-item-0">Your Profile</a>

                    <a href="#" class="block px-4 py-2 text-sm text-gray-700" role="menuitem" tabindex="-1" id="user-menu-item-1">Settings</a>

                    <a href="#" class="block px-4 py-2 text-sm text-gray-700" role="menuitem" tabindex="-1" id="user-menu-item-2">Sign out</a>
                  </div>
                </div>
              </div>
            </div>
            <div class="-mr-2 flex md:hidden">
              <!-- Mobile menu button -->
              <button
                phx-click={
                  JS.toggle(
                    to: "#mobile-menu",
                    in: {"transition ease-out duration-100", "scale-y-0", "scale-y-100"},
                    out: {"transition ease-in duration-75", "scale-y-100", "scale-y-0"}
                  )
                  |> JS.toggle(to: ".mobile-menu-button-open")
                  |> JS.toggle(to: ".mobile-menu-button-close")
                }
                type="button"
                class="bg-gray-800 inline-flex items-center justify-center p-2 rounded-md text-gray-400 hover:text-white hover:bg-gray-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-offset-gray-800 focus:ring-white"
                aria-controls="mobile-menu"
                aria-expanded="false"
              >
                <span class="sr-only">Open main menu</span>
                <.icon name="menu" type="outline" class="mobile-menu-button-open block h-6 w-6" />
                <.icon name="x" type="outline" class="mobile-menu-button-close hidden h-6 w-6" />
              </button>
            </div>
          </div>
        </div>

        <!-- Mobile menu, show/hide based on menu state. -->
        <div class="md:hidden" id="mobile-menu-container">
          <div class="hidden z-50 bg-gray-800 origin-top absolute w-full" id="mobile-menu" phx-remove={JS.hide(transition: {"transition ease-in duration-75", "scale-y-100", "scale-y-0"})}>
            <div class="px-2 pt-2 pb-3 space-y-1 sm:px-3">
              <%= for menu_item <- menu_items() do %>
                <%= live_redirect(menu_item.label, to: menu_item.path, class: get_mobile_item_class(menu_item, @current_menu)) %>
              <% end %>
            </div>
            <div class="pt-4 pb-3 border-t border-gray-700">
              <div class="flex items-center px-5">
                <div class="flex-shrink-0">
                  <img class="h-10 w-10 rounded-full" src="https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80" alt="">
                </div>
                <div class="ml-3">
                  <div class="text-base font-medium leading-none text-white">Tom Cook</div>
                  <div class="text-sm font-medium leading-none text-gray-400">tom@example.com</div>
                </div>
                <button type="button" class="ml-auto bg-gray-800 flex-shrink-0 p-1 rounded-full text-gray-400 hover:text-white focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-offset-gray-800 focus:ring-white">
                  <span class="sr-only">View notifications</span>
                  <.icon name="bell" type="outline" class="h-6 w-6" />
                </button>
              </div>
              <div class="mt-3 px-2 space-y-1">
                <a href="#" class="block px-3 py-2 rounded-md text-base font-medium text-gray-400 hover:text-white hover:bg-gray-700">Your Profile</a>

                <a href="#" class="block px-3 py-2 rounded-md text-base font-medium text-gray-400 hover:text-white hover:bg-gray-700">Settings</a>

                <a href="#" class="block px-3 py-2 rounded-md text-base font-medium text-gray-400 hover:text-white hover:bg-gray-700">Sign out</a>
              </div>
            </div>
          </div>
        </div>
      </nav>

      <header class="bg-white shadow">
        <div class="py-6 px-4 sm:px-6 lg:px-8">
          <h1 id="page-title" class="fade-in text-3xl font-bold text-gray-900">
            <%= @title %>
          </h1>
        </div>
      </header>
      <main id="page-main">
        <div class="fade-in py-6 px-4 sm:px-6 lg:px-8">
          <%= render_slot(@inner_block) %>
        </div>
      </main>
    </div>
    """
  end

  defp get_item_class(menu_item, current_menu) do
    if current_menu == menu_item.id do
      "bg-gray-900 text-white px-3 py-2 rounded-md text-sm font-medium"
    else
      "text-gray-300 hover:bg-gray-700 hover:text-white px-3 py-2 rounded-md text-sm font-medium"
    end
  end

  defp get_mobile_item_class(menu_item, current_menu) do
    if current_menu == menu_item.id do
      "bg-gray-900 text-white block px-3 py-2 rounded-md text-base font-medium"
    else
      "text-gray-300 hover:bg-gray-700 hover:text-white block px-3 py-2 rounded-md text-base font-medium"
    end
  end

  defp hide_profile_menu(js \\ %JS{}) do
    js
    |> JS.hide(
      to: "#profile-menu",
      transition: {
        "transition ease-in duration-75",
        "opacity-100 scale-100",
        "opacity-0 scale-95"
      }
    )
  end

  defp toggle_profile_menu(js \\ %JS{}) do
    js
    |> JS.toggle(
      to: "#profile-menu",
      in: {
        "transition ease-out duration-100",
        "opacity-0 scale-95",
        "opacity-100 scale-100"
      },
      out: {
        "transition ease-in duration-75",
        "opacity-100 scale-100",
        "opacity-0 scale-95"
      }
    )
  end

  defp on_remove(js \\ %JS{}) do
    js
    |> JS.hide(to: "#page-main", transition: "fade-out", time: 75)
    |> JS.hide(to: "#page-title", transition: "fade-out", time: 75)
  end
end

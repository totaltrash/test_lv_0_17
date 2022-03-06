defmodule IFixComponents.Nav do
  use Phoenix.Component

  import Heroicons.LiveView
  import IFixComponents.Link

  @active_classes "active_tab bg-sky-200 text-sky-800"

  # assigns:
  #     :current      required: true, which nav_item is the current
  #
  # slots:
  #   :nav_item
  #     :label        required: true, label to display in the nav_item
  #     :icon         required: false, optional icon to display in the nav_item
  def nav(assigns) do
    assigns =
      assigns
      |> assign_new(:nav_item, fn -> [] end)

    ~H"""
    <div class="flex flex-row gap-4 items-center">
      <%= for nav_item <- @nav_item do %>
        <.link
          href={nav_item.href}
          class={"flex flex-row flex-nowrap items-center gap-2 px-4 py-2 rounded bg-gray-100 text-gray-600 font-medium #{get_active_nav_item_class(@current, nav_item.id)}"}
        >
          <%= if nav_item[:icon] do %>
            <.icon name={nav_item.icon} type="solid" class="h-4 w-4" />
          <% end %>
            <span class="whitespace-nowrap"><%= nav_item.label %></span>
        </.link>
      <% end %>
    </div>
    """
  end

  defp get_active_nav_item_class(current, current) do
    @active_classes
  end

  defp get_active_nav_item_class(_current, _nav_item_id) do
    ""
  end
end

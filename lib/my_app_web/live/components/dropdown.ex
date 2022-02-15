defmodule MyAppWeb.Dropdown do
  use Phoenix.Component
  import Heroicons.LiveView
  import MyAppWeb.Button
  import MyAppWeb.Link
  alias Phoenix.LiveView.JS

  defp toggle_dropdown(id, js \\ %JS{}) do
    js
    |> JS.toggle(
      to: "##{id}_dropdown",
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

  defp hide_dropdown(id, js \\ %JS{}) do
    js
    |> JS.hide(
      to: "##{id}_dropdown",
      transition: {
        "transition ease-in duration-75",
        "opacity-100 scale-100",
        "opacity-0 scale-95"
      }
    )
  end

  # assigns:
  #     :id           required: true (dom id for the dropdown, required as it is used by JS to toggle dropdown contents)
  #     :label        required: true (to display in the dropdown button)
  #     :color        required: false, default: "default", (passed straight to the .button component, so any value valid there)
  #     :direction    required: false, default: "up", options: ["up", "down"]
  #     :align        required: false, default: "right", options: ["right", "left"]
  def dropdown(assigns) do
    assigns =
      assigns
      |> assign_new(:color, fn -> "default" end)
      |> assign_new(:direction, fn -> "down" end)
      |> assign_new(:align, fn -> "right" end)
      |> assign_new(:icon, fn -> nil end)

    ~H"""
    <div id={@id} class="p-0 m-0 relative inline-block text-left">
      <.button
        id={"#{@id}_button"}
        type="button"
        color={@color}
        label={@label}
        click={toggle_dropdown(@id)}
        icon={@icon}
        right_icon={dropdown_icon(@direction)}
      />
      <div
        id={"#{@id}_dropdown"}
        phx-remove={hide_dropdown(@id)}
        phx-click={hide_dropdown(@id)}
        phx-click-away={hide_dropdown(@id)}
        phx-window-keydown={hide_dropdown(@id)}
        phx-key="escape"
        class={"hidden #{dropdown_base_class()} #{dropdown_margin(@direction)} #{dropdown_align(@align)} #{dropdown_origin(@direction, @align)}"}
        role="menu"
        aria-orientation="vertical"
        aria-labelledby={"#{@id}_button"}
        tabindex="-1"
      >
        <div class="py-1" role="none">
          <%= render_slot(@inner_block) %>
        </div>
      </div>
    </div>
    """
  end

  def dropdown_heading(assigns) do
    ~H"""
      <span class="tracking-tight text-gray-500 font-medium block px-4 py-2 text-sm">
        <%= @label %>
      </span>
    """
  end

  def dropdown_divider(assigns) do
    ~H"""
      <hr class="my-1" />
    """
  end

  def dropdown_link(assigns) do
    extra_attributes = assigns_to_attributes(assigns, [:label])

    assigns =
      assigns
      |> assign(:extra_attributes, extra_attributes)
      |> assign_new(:icon, fn -> nil end)

    ~H"""
      <.link {@extra_attributes} class="text-gray-700 block px-4 py-2 text-sm hover:bg-gray-100">
        <span class="block inline-flex items-center">
          <.dropdown_link_icon icon={@icon} /><%= @label %>
        </span>
      </.link>
    """
  end

  defp dropdown_link_icon(%{icon: nil} = assigns), do: ~H[]

  defp dropdown_link_icon(assigns) do
    ~H"""
    <.icon name={@icon} type="solid" class="h-4 w-4 -ml-1 mr-2 text-gray-500" />
    """
  end

  defp dropdown_margin("down"), do: "mt-2"
  defp dropdown_margin("up"), do: "mb-11 bottom-0"

  defp dropdown_align("left"), do: "left-0"
  defp dropdown_align("right"), do: "right-0"

  defp dropdown_origin("down", "right"), do: "origin-top-right"
  defp dropdown_origin("down", "left"), do: "origin-top-left"
  defp dropdown_origin("up", "right"), do: "origin-bottom-right"
  defp dropdown_origin("up", "left"), do: "origin-bottom-left"

  defp dropdown_icon("up"), do: "chevron-up"
  defp dropdown_icon("down"), do: "chevron-down"

  defp dropdown_base_class(),
    do:
      "absolute w-56 shadow-lg bg-white ring-1 ring-black ring-opacity-5 focus:outline-none rounded"

  # defp dropdown_class(direction, align) do
  #   [
  #     {"mt-2", direction == "down"},
  #     {"mb-11 bottom-0", direction == "up"},
  #     {"left-0", align == "left"},
  #     {"right-0", align == "right"},
  #     {"origin-top-right", direction == "down" and align == "right"},
  #     {"origin-top-left", direction == "down" and align == "left"},
  #     {"origin-bottom-right", direction == "up" and align == "right"},
  #     {"origin-bottom-left", direction == "up" and align == "left"},
  #     "absolute w-56 shadow-lg bg-white ring-1 ring-black ring-opacity-5 focus:outline-none rounded"
  #   ]
  #   |> Enum.map(fn class ->
  #     if is_tuple(class), do: class, else: {class, true}
  #   end)

  #   # |> Enum.filter(fn class -> do  end)
  # end
end

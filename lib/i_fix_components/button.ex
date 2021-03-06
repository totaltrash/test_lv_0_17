defmodule IFixComponents.Button do
  use Phoenix.Component

  import IFixComponents.Link
  import Heroicons.LiveView

  # assigns:
  #     :label        required: false, default: nil (component expects a slot if no label)
  #     :color        required: false, default: "default", options: ["default", "danger", {:custom, "custome classes"}]
  #     :size         required: false, default: "normal", options: ["normal"]

  # All extra attributes are passed on to the link component, so see the assigns
  # for that (stuff like link_type, link_state)
  def button(%{type: "link"} = assigns) do
    extra_attributes =
      assigns_to_attributes(assigns, [
        :type,
        :label,
        :color,
        :size,
        :icon,
        :right_icon
      ])

    assigns =
      assigns
      |> assign(:extra_attributes, extra_attributes)
      |> assign_new(:label, fn -> nil end)
      |> assign_new(:color, fn -> "default" end)
      |> assign_new(:size, fn -> "normal" end)
      |> assign_new(:icon, fn -> nil end)
      |> assign_new(:right_icon, fn -> nil end)

    ~H"""
      <.link
        {@extra_attributes}
        class={"#{base_class()} #{color(@color)} #{size(@size)}"}
      >
        <.button_icon icon={@icon}/>
        <%= @label || render_slot(@inner_block) %>
        <.right_button_icon icon={@right_icon}/>
      </.link>
    """
  end

  # assigns:
  #     :label        required: false, default: nil (component expects a slot if no label)
  #     :color        required: false, default: "default", options: ["default", "danger", {:custom, "custome classes"}]
  #     :size         required: false, default: "md", options: ["sm", "md", "lg"]

  def button(%{type: "submit"} = assigns) do
    extra =
      assigns_to_attributes(assigns, [
        :type,
        :label,
        :color,
        :size,
        :icon,
        :right_icon
      ])

    assigns =
      assigns
      |> assign(:extra, extra)
      |> assign_new(:label, fn -> nil end)
      |> assign_new(:color, fn -> "default" end)
      |> assign_new(:size, fn -> "normal" end)
      |> assign_new(:icon, fn -> nil end)
      |> assign_new(:right_icon, fn -> nil end)

    ~H"""
      <button
        type="submit"
        {@extra}
        class={"#{base_class()} #{color(@color)} #{size(@size)}"}
      >
        <.button_icon icon={@icon}/>
        <%= @label || render_slot(@inner_block) %>
        <.right_button_icon icon={@right_icon}/>
      </button>
    """
  end

  # assigns:
  #     :type         required: false, default: "button"
  #     :label        required: false, default: nil (component expects a slot if no label)
  #     :color        required: false, default: "default", options: ["default", "danger", {:custom, "custome classes"}]
  #     :size         required: false, default: "md", options: ["sm", "md", "lg"]
  #     :click        required: true (could change this to not required when relying on whatever extra attributes are attached to the button?)

  def button(assigns) do
    extra =
      assigns_to_attributes(assigns, [
        :type,
        :label,
        :color,
        :size,
        :icon,
        :right_icon,
        :click
      ])

    assigns =
      assigns
      |> assign(:extra, extra)
      |> assign_new(:type, fn -> "button" end)
      |> assign_new(:label, fn -> nil end)
      |> assign_new(:color, fn -> "default" end)
      |> assign_new(:size, fn -> "normal" end)
      |> assign_new(:icon, fn -> nil end)
      |> assign_new(:right_icon, fn -> nil end)

    ~H"""
      <button
        type={@type}
        phx-click={@click}
        {@extra}
        class={"#{base_class()} #{color(@color)} #{size(@size)}"}
      >
        <.button_icon icon={@icon}/>
        <%= @label || render_slot(@inner_block) %>
        <.right_button_icon icon={@right_icon}/>
      </button>
    """
  end

  defp base_class(),
    do:
      "flex items-center justify-center border rounded focus:outline-none focus:ring-2 focus:ring-offset-2"

  def color("primary"),
    do: "bg-sky-600 hover:bg-sky-700 text-white border-transparent focus:ring-sky-500"

  def color("danger"),
    do: "bg-red-600 hover:bg-red-700 text-white border-transparent focus:ring-red-500"

  def color("modal_default"),
    do: "bg-white hover:bg-gray-50 text-gray-700 border-gray-300 focus:ring-gray-300"

  def color({:custom, classes}), do: classes

  def color(_default),
    do: "bg-gray-50 hover:bg-gray-100 text-gray-700 border-gray-300 focus:ring-gray-300"

  # Size colors only take effect from md and bigger viewports
  defp size("sm"), do: "px-4 py-2 text-base font-medium md:py-1 md:text-xs md:px-3"
  defp size("lg"), do: "px-4 py-2 text-base font-medium md:py-3 md:text-xl md:px-6"
  defp size(_), do: "px-4 py-2 text-base font-medium md:py-2 md:px-4 md:text-sm"

  defp button_icon(%{icon: nil} = assigns), do: ~H[]

  defp button_icon(assigns) do
    ~H"""
      <.icon name={@icon} type="solid" class="-ml-2 mr-1 h-5 w-5" />
    """
  end

  defp right_button_icon(%{icon: nil} = assigns), do: ~H[]

  defp right_button_icon(assigns) do
    ~H"""
      <.icon name={@icon} type="solid" class="-mr-2 ml-1 h-5 w-5" />
    """
  end
end

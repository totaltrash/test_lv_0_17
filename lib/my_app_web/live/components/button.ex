defmodule MyAppWeb.Button do
  use Phoenix.Component

  # assigns:
  #     :label        required: false, default: nil (component expects a slot if no label)
  #     :variant      required: false, default: "default", options: ["default", "danger", {:custom, "custome classes"}]
  #     :size         required: false, default: "normal", options: ["normal"]
  #     :link_type    required: false, default: "patch", options: ["patch", "redirect"]
  #     :link_state   required: false, default: "push", options: ["push", "replace"]
  def button(%{type: "link"} = assigns) do
    extra =
      assigns_to_attributes(assigns, [
        :type,
        :label,
        :variant,
        :size,
        :link_type,
        :link_state
      ])

    assigns =
      assigns
      |> assign(:extra, extra)
      |> assign_new(:label, fn -> nil end)
      |> assign_new(:variant, fn -> "default" end)
      |> assign_new(:size, fn -> "normal" end)
      |> assign_new(:link_type, fn -> "patch" end)
      |> assign_new(:link_state, fn -> "push" end)

    ~H"""
      <a
        {@extra}
        data-phx-link={@link_type}
        data-phx-link-state={@link_state}
        class={"#{variant(@variant)} #{size(@size)} #{base_class()}"}
      >
        <%= @label || render_slot(@inner_block) %>
      </a>
    """
  end

  # assigns:
  #     :label        required: false, default: nil (component expects a slot if no label)
  #     :variant      required: false, default: "default", options: ["default", "danger", {:custom, "custome classes"}]
  #     :size         required: false, default: "md", options: ["sm", "md", "lg"]

  def button(%{type: "submit"} = assigns) do
    extra =
      assigns_to_attributes(assigns, [
        :type,
        :label,
        :variant,
        :size
      ])

    assigns =
      assigns
      |> assign(:extra, extra)
      |> assign_new(:label, fn -> nil end)
      |> assign_new(:variant, fn -> "default" end)
      |> assign_new(:size, fn -> "normal" end)

    ~H"""
      <button
        type="submit"
        {@extra}
        class={"#{base_class()} #{variant(@variant)} #{size(@size)}"}
      >
        <%= @label || render_slot(@inner_block) %>
      </button>
    """
  end

  # assigns:
  #     :type         required: false, default: "button"
  #     :label        required: false, default: nil (component expects a slot if no label)
  #     :variant      required: false, default: "default", options: ["default", "danger", {:custom, "custome classes"}]
  #     :size         required: false, default: "md", options: ["sm", "md", "lg"]
  #     :click        required: true (could change this to not required when relying on whatever extra attributes are attached to the button?)

  def button(assigns) do
    extra =
      assigns_to_attributes(assigns, [
        :type,
        :label,
        :variant,
        :size,
        :click
      ])

    assigns =
      assigns
      |> assign(:extra, extra)
      |> assign_new(:type, fn -> "button" end)
      |> assign_new(:label, fn -> nil end)
      |> assign_new(:variant, fn -> "default" end)
      |> assign_new(:size, fn -> "normal" end)

    ~H"""
      <button
        type={@type}
        phx-click={@click}
        {@extra}
        class={"#{base_class()} #{variant(@variant)} #{size(@size)}"}
      >
        <%= @label || render_slot(@inner_block) %>
      </button>
    """
  end

  defp base_class(),
    do:
      "flex items-center justify-center border rounded-md focus:outline-none focus:ring-2 focus:ring-offset-2"

  def variant("primary"),
    do: "bg-sky-600 hover:bg-sky-700 text-white border-transparent focus:ring-sky-500"

  def variant("danger"),
    do: "bg-red-600 hover:bg-red-700 text-white border-transparent focus:ring-red-500"

  def variant("modal_default"),
    do: "bg-white hover:bg-gray-50 text-gray-700 border-gray-300 focus:ring-gray-300"

  def variant({:custom, classes}), do: classes

  def variant(_default),
    do: "bg-gray-50 hover:bg-gray-100 text-gray-700 border-gray-300 focus:ring-gray-300"

  # Size variants only take effect from md and bigger viewports
  defp size("sm"), do: "px-4 py-2 text-base font-medium md:py-1 md:text-xs md:px-3"
  defp size("lg"), do: "px-4 py-2 text-base font-medium md:py-3 md:text-xl md:px-6"
  defp size(_), do: "px-4 py-2 text-base font-medium md:py-2 md:px-4 md:text-sm"
end

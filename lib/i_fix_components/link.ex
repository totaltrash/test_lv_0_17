defmodule IFixComponents.Link do
  use Phoenix.Component

  # assigns:
  #     :label        required: false, default: nil (component expects a slot if no label)
  #     :color        required: false, default: "default", options: ["default", "danger", {:custom, "custome classes"}]
  #     :link_type    required: false, default: "patch", options: ["patch", "redirect", "external"]
  #     :link_state   required: false, default: "push", options: ["push", "replace"]
  #     :class        required: false, (treated as an extra attribute, if added, allows to override the classes used internally, will ignore the color. For fine tuning appearance, used by buttons etc)
  def link(assigns) do
    extra_attributes =
      assigns_to_attributes(assigns, [
        :label,
        :color,
        :link_type,
        :link_state,
        :class
      ])

    assigns =
      assigns
      |> assign(:extra_attributes, extra_attributes)
      |> assign_new(:label, fn -> nil end)
      # Below are not directly used in template...
      |> assign_new(:color, fn -> "default" end)
      |> assign_new(:link_type, fn -> "patch" end)
      |> assign_new(:link_state, fn -> "push" end)
      # ... but are used by the following assign functions
      |> assign_type_attributes()
      |> assign_class()

    ~H"""
      <a
        class={@class}
        {@type_attributes}
        {@extra_attributes}
      >
        <%= @label || render_slot(@inner_block) %>
      </a>
    """
  end

  defp assign_type_attributes(%{link_type: "external"} = assigns) do
    assign(assigns, type_attributes: [])
  end

  defp assign_type_attributes(%{link_type: link_type, link_state: link_state} = assigns) do
    assign(assigns,
      type_attributes: [
        "data-phx-link": link_type,
        "data-phx-link-state": link_state
      ]
    )
  end

  defp assign_class(%{class: class} = assigns) do
    assign(assigns, class: class)
  end

  defp assign_class(assigns) do
    assign(assigns, class: "#{base_class()} #{color(assigns.color)}")
  end

  defp base_class(), do: "focus:outline-none"

  defp color("danger"), do: "text-red-600 hover:text-red-800 focus:text-red-800"
  defp color({:custom, classes}), do: classes
  defp color(_default), do: "text-sky-600 hover:text-sky-800 focus:text-sky-800"
end

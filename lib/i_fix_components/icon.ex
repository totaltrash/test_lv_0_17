defmodule IFixComponents.Icon do
  use Phoenix.Component
  import Heroicons.LiveView

  # assigns:
  #     :value        required: true, boolean
  #     :class        required: false, default: "h-6 w-6"
  #     :type         required: false, default: "outline", options: ["outline", "solid"]
  def boolean_icon(assigns) do
    assigns =
      assigns
      |> assign(icon: if(assigns.value, do: "check", else: "x"))
      |> assign_new(:class, fn -> "h-6 w-6" end)
      |> assign_new(:type, fn -> "outline" end)

    ~H"""
    <.icon name={@icon} type={@type} class={@class} />
    """
  end
end

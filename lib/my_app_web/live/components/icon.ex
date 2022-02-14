defmodule MyAppWeb.Icon do
  use Phoenix.Component
  import Heroicons.LiveView

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

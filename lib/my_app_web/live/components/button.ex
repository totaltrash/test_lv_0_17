defmodule MyAppWeb.Button do
  use Phoenix.Component

  # waiting for declarative assigns to land in live view before doing more

  def button(assigns) do
    extra = assigns_to_attributes(assigns, [:title])

    assigns =
      assigns
      |> assign(:extra, extra)
      |> assign_new(:variant, fn -> :default end)

    ~H"""
      <a {@extra} class={"#{get_variant(@variant)} flex items-center justify-center px-4 py-2 border border-transparent text-base font-medium rounded text-white md:py-3 md:text-lg md:px-6"}>
        <%= render_slot(@inner_block) %>
      </a>
    """
  end

  defp get_variant(:default), do: "bg-blue-600 hover:bg-blue-700"
  defp get_variant(:danger), do: "bg-red-600 hover:bg-red-700"
end

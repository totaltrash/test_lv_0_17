defmodule MyAppWeb.Form do
  use Phoenix.Component

  def field_row(assigns) do
    ~H"""
      <div class="my-4">
        <%= render_slot(@inner_block) %>
      </div>
    """
  end
end

defmodule MyAppWeb.Form do
  use Phoenix.Component
  import Heroicons.LiveView
  import Phoenix.HTML.Form

  def field_row(assigns) do
    ~H"""
      <div class="my-4">
        <%= render_slot(@inner_block) %>
      </div>
    """
  end

  def clearable_text_input(assigns) do
    ~H"""
    <div data-role="clearable-text-input-container" class="relative">
      <%= text_input @form, @field, value: @value, autocomplete: "off" %>
      <span class="absolute inset-y-0 flex items-center right-0 pr-2">
        <%= if @value != "" do %>
          <button
            id={@form.id <> "_" <> to_string(@field) <> "_clear"}
            phx-hook="ClearTextInput"
            type="button"
            class="focus:outline-none"
            value={@field}
          >
            <.icon name="x" type="solid" class="h-6 w-6 text-gray-300 hover:text-gray-400" />
          </button>
        <% end %>
      </span>
    </div>
    """
  end
end

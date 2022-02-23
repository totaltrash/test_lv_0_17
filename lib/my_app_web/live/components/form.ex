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

  # assigns:
  #     :form         required: true
  #     :field        required: true
  #     :value        required: true
  #     :class        required: false, default: nil, optional extra classes to apply on the text input
  #     extras        required: false, all extra attributes will be applied to the text_input
  def clearable_text_input(assigns) do
    extra_attributes =
      assigns_to_attributes(assigns, [
        :form,
        :field,
        :value,
        :class
      ])

    assigns =
      assigns
      |> assign_new(:class, fn -> nil end)
      |> assign(extra_attributes: extra_attributes)

    ~H"""
    <div data-role="clearable-text-input-container" class="relative">
      <%= text_input @form, @field, [value: @value, autocomplete: "off", class: @class] ++ @extra_attributes %>
      <span class="absolute inset-y-0 flex items-center right-0 pr-2">
        <%= if @value != "" do %>
          <button
            id={"#{input_id(@form, @field)}_clear"}
            phx-hook="ClearTextInput"
            type="button"
            class="focus:outline-none"
          >
            <.icon name="x" type="solid" class="h-6 w-6 text-gray-300 hover:text-gray-400" />
          </button>
        <% end %>
      </span>
    </div>
    """
  end
end

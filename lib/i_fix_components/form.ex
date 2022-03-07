defmodule IFixComponents.Form do
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

  def checkbox_array(assigns) do
    {selected, _} = get_selected_values(assigns[:form], assigns[:field], [])
    selected_as_strings = Enum.map(selected, &"#{&1}")

    assigns = assign(assigns, selected_as_strings: selected_as_strings)

    ~H"""
    <div class="flex flex-col gap-1 my-1">
      <%= for {label, key} <- @options do %>
        <div class="flex flex-row items-center">
          <%= checkbox @form, @field, id: input_id(@form, @field, key), name: input_name(@form, @field) <> "[]", value: key, class: "mr-2", checked_value: key, hidden_input: false, checked: Enum.member?(@selected_as_strings, "#{key}") %>
          <%= label @form, @field, label, for: input_id(@form, @field, key) %>
        </div>
      <% end %>
    </div>
    """
  end

  # THIS IS ALL COPIED FROM https://elixirforum.com/t/many-to-many-checkbox-form/17216/6 which
  # was also copied from Phoenix.Html.Form... and is duplicated - @todo, move to own helper module
  defp get_selected_values(form, field, opts) do
    {selected, opts} = Keyword.pop(opts, :selected)
    param = field_to_string(field)

    case form do
      %{params: %{^param => sent}} ->
        {sent, opts}

      _ ->
        {selected || sanitized_input_value(form, field), opts}
    end
  end

  # Might come back to bite. When creating a new changeset, you either need to explicitly
  # add the related field to the params, or it will be reported here as Ash.NotLoaded. So
  # lets assume that if the input value is not a list, then make it an empty list
  defp sanitized_input_value(form, field) do
    input_value = input_value(form, field)

    if is_list(input_value) do
      input_value
    else
      []
    end
  end

  defp field_to_string(field) when is_atom(field), do: Atom.to_string(field)
  defp field_to_string(field) when is_binary(field), do: field

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

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

  # Bit of an opinionated design, not sure how it's going to work outside of the
  # one use that it was getting (search box in data_tables):
  #  * The clear button submits the form
  #  * Use JS command to clear the text element?
  #  * Probably better to emit some event on click, that happens
  #    after the clear hook, if possible??? so parent can submit
  #    or whatever... maybe pass a JS command to call that can
  #    be run after the clear command
  def clearable_text_input(assigns) do
    ~H"""
    <div data-role="clearable-text-input-container" class="relative">
      <%= text_input @form, @field, value: @value, autocomplete: "off" %>
      <!--<Form.TextInput value={@value} class={@class} opts={[autocomplete: "off"] ++ @opts}/>-->
      <span class="absolute inset-y-0 flex items-center right-0 pr-2">
        <button
          :if={@value != ""}
          id={@form.id <> "-" <> to_string(@field) <> "-clear"}
          phx-hook="ClearTextInput"
          type="submit"
          class="focus:outline-none"
        >
          <.icon name="x" type="solid" class="h-6 w-6 text-gray-300 hover:text-gray-400" />
        </button>
      </span>
    </div>
    """
  end
end

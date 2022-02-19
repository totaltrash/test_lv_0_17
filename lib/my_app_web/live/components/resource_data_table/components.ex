defmodule MyAppWeb.ResourceDataTable.Components do
  use Phoenix.Component

  import MyAppWeb.Form
  import Phoenix.HTML.Form

  def filter_text_input(assigns) do
    ~H"""
    <.clearable_text_input
      form={@context.form}
      field={@field}
      value={@context.values[@field]}
      class="w-full sm:w-64 pr-10 sm:flex-shrink"
    />
    """
  end

  def filter_checkbox(assigns) do
    ~H"""
    <%= checkbox @context.form, @field, value: @context.values[@field] %>
    """
  end
end

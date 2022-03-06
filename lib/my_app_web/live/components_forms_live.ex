defmodule MyAppWeb.ComponentsFormsLive do
  use MyAppWeb, :live_view

  import IFixComponents.Page
  import IFixComponents.Form
  import IFixComponents.Button
  import MyAppWeb.ComponentsLive.Components

  def mount(_, _session, socket) do
    socket =
      socket
      |> assign(options_int_value: [Administrator: 1, User: 2])

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.wrapper current_menu="components" title="Components">
      <.components_container>
        <.components_nav current="forms" />
      </.components_container>

      <.h1>Checkbox Array</.h1>
      <.h2>Int values</.h2>
      <.components_container>
        <.form let={f} for={:form} phx-submit="checkbox_array_submit" phx-change="checkbox_array_change">
          <.checkbox_array form={f} field={:roles} options={@options_int_value} />
          <.button type="submit" label="Submit" color="primary" />
        </.form>
      </.components_container>

      <.h1>Clearable Text Input</.h1>
      <.components_container>
        <.form let={f} for={:form} phx-submit="form_submit">
          <.clearable_text_input
            form={f}
            field={:test_clearable}
            value="Test"
          />
        </.form>
      </.components_container>

    </.wrapper>
    """
  end

  def handle_event("checkbox_array_change", params, socket) do
    IO.inspect(params)

    socket =
      socket
      |> add_toast(:info, "Changed checkbox array")

    {:noreply, socket}
  end
end

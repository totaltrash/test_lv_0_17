defmodule MyAppWeb.ResourceDataTableV1 do
  use MyAppWeb, :live_component

  alias MyAppWeb.Session
  import MyAppWeb.Paginator
  import MyAppWeb.Form

  def mount(socket) do
    socket =
      socket
      |> assign_new(:action, fn -> :filtered_paginated_list end)
      |> assign_new(:page_size, fn -> 10 end)

    {:ok, socket}
  end

  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign_session_keys()
      |> assign_filter()
      |> assign_page()

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <.form let={f} for={:filter} phx-change="filter" phx-submit="filter" class="mb-6 flex flex-col sm:flex-row sm:items-center gap-4">
        <.clearable_text_input
          form={f}
          field={:keyword}
          value={@filter[:keyword]}
          class="w-full sm:w-64 pr-10 sm:flex-shrink"
        />
      </.form>
      <%= render_slot(@inner_block, @page.results) %>
      <.paginator offset={@page.offset} limit={@page.limit} count={@page.count} size={3} change_page="change_page" />
    </div>
    """
  end

  defp assign_filter(socket) do
    filter =
      Session.get(
        socket.assigns.session_id,
        socket.assigns.session_key_filter,
        %{keyword: "", active: true}
      )

    assign(socket, filter: filter)
  end

  defp assign_filter(socket, filter) do
    assign(socket, filter: filter)
  end

  defp assign_page(socket) do
    page_no = Session.get(socket.assigns.session_id, socket.assigns.session_key_page, 1)
    offset = (page_no - 1) * socket.assigns.page_size

    page =
      socket.assigns.resource
      |> Ash.Query.for_read(socket.assigns.action, filter: socket.assigns.filter)
      |> socket.assigns.api.read!(
        page: [limit: socket.assigns.page_size, count: true, offset: offset]
      )

    assign(socket, page: page)
  end

  defp assign_session_keys(socket) do
    socket
    |> assign(:session_key_page, String.to_atom(socket.assigns.session_key <> "_page"))
    |> assign(:session_key_filter, String.to_atom(socket.assigns.session_key <> "_filter"))
  end
end

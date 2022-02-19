defmodule MyAppWeb.ResourceDataTable do
  use MyAppWeb, :live_component

  # alias MyAppWeb.Session
  import MyAppWeb.Paginator
  import MyAppWeb.Form

  @default_pagination_page_size 10

  def mount(socket) do
    socket =
      socket
      |> assign_new(:class, fn -> nil end)
      |> assign_new(:filter, fn -> nil end)
      |> assign_new(:pagination, fn -> nil end)
      # |> assign_new(:page_size, fn -> 10 end)
      |> assign_new(:action, fn -> :data_table end)

    # |> assign_plugin_config()
    # |> assign_pagination_plugin()

    # |> assign_filter_map_plugin()
    # |> assign_sort_plugin()
    # |> assign_session_plugin()

    {:ok, socket}
  end

  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      # |> assign_session_keys()
      |> assign_filter_map()
      |> assign_results()

    {:ok, socket}
  end

  def render(assigns) do
    # IO.inspect(assigns)

    ~H"""
    <div class={@class}>
      <%= if @filter do %>
        <.form
          let={form}
          for={:filter}
          phx-change="filter"
          phx-submit="filter"
          phx-target={@myself}
          class="py-2 px-5 bg-white flex flex-col sm:flex-row sm:items-center gap-6"
        >
          <%= for filter <- @filter do %>
            <.filter_control filter={filter} form={form} value={@filter_map[filter.field]} />
          <% end %>
        </.form>
      <% end %>
      <%= if @pagination do %>
        <%= render_slot(@inner_block, @page.results) %>
        <.paginator
          offset={@page.offset}
          limit={@page.limit}
          count={@page.count}
          size={3}
          change_page="change_page"
          change_page_target={@myself}
        />
      <% else %>
        <%= render_slot(@inner_block, @results) %>
      <% end %>
    </div>
    """
  end

  defp filter_control(%{filter: %{type: "text"}} = assigns) do
    ~H"""
      <.clearable_text_input
        form={@form}
        field={@filter.field}
        value={@value}
        ZZZclass="w-full sm:w-64 pr-10 sm:flex-shrink"
      />
    """
  end

  defp filter_control(%{filter: %{type: "checkbox"}} = assigns) do
    ~H"""
      <%= checkbox @form, @filter.field, value: @value %>
    """
  end

  defp filter_control(%{filter: %{type: "custom"}} = assigns) do
    ~H"""
      <%= render_slot(@filter, %{form: @form, field: @filter.field, value: @value}) %>
    """
  end

  defp assign_results(%{assigns: %{pagination: nil}} = socket) do
    results =
      socket.assigns.resource
      |> Ash.Query.for_read(socket.assigns.action, filter: socket.assigns.filter_map)
      |> socket.assigns.api.read!()

    assign(socket, results: results)
  end

  defp assign_results(%{assigns: %{pagination: [pagination | _]}} = socket) do
    # page_no = Session.get(socket.assigns.session_id, socket.assigns.session_key_page, 1)
    page_no = 1

    page_size = pagination[:page_size] || @default_pagination_page_size
    offset = (page_no - 1) * page_size

    page =
      socket.assigns.resource
      |> Ash.Query.for_read(socket.assigns.action, filter: socket.assigns.filter_map)
      |> socket.assigns.api.read!(page: [limit: page_size, count: true, offset: offset])

    assign(socket, page: page)
  end

  # ### IS THIS THE CORRECT GUARD???
  # defp assign_filter_map(%{assigns: %{filter: filter}} = socket) when is_list(filter) do
  #   # IO.inspect(socket.assigns.filter)
  #   # filter_map =
  #   #   Session.get(
  #   #     socket.assigns.session_id,
  #   #     socket.assigns.session_key_filter,
  #   #     %{keyword: "", active: true}
  #   #   )
  #   filter_map = hd(socket.assigns.filter).initial_filter

  #   assign(socket, filter_map: filter_map)
  # end

  # ### DEFAULT THIS IN MOUNT?
  defp assign_filter_map(socket) do
    IO.puts("HERE!!!")
    assign(socket, filter_map: %{})
  end

  defp assign_filter_map(socket, filter_map) do
    assign(socket, filter_map: filter_map)
  end

  def handle_event("change_page", %{"page" => page_no}, socket) do
    page_no = String.to_integer(page_no)
    # Session.set(socket.assigns.session_id, socket.assigns.session_key_page, page_no)

    {:noreply, assign(socket, page: socket.assigns.api.page!(socket.assigns.page, page_no))}
  end

  def handle_event("filter", %{"filter" => filter}, socket) do
    # %{"keyword" => keyword, "active" => active} = filter

    # filter = %{
    #   keyword: keyword,
    #   active: String.to_existing_atom(active)
    # }

    # filter =
    #   filter
    #   |> Jason.encode!()
    #   |> Jason.decode!(keys: :atoms)

    filter = normalize_filter_map(filter, socket.assigns.filter)
    IO.inspect(filter)

    socket =
      socket
      |> assign_filter_map(filter)
      |> assign_results()

    {:noreply, socket}
  end

  defp normalize_filter_map(filter_map, filter_configs) do
    filter_map
    |> Map.new(fn {key, value} ->
      key = String.to_atom(key)

      value =
        case Enum.find(filter_configs, fn filter_config -> filter_config.field == key end) do
          nil -> value
          filter_config -> normalize_filter_element(filter_config, value)
        end

      {key, value}
    end)
  end

  defp normalize_filter_element(%{normalize: "integer"}, value) do
    case Integer.parse(value) do
      {int_value, _} -> int_value
      _ -> nil
    end
  end

  defp normalize_filter_element(%{normalize: "boolean"}, value) do
    String.to_existing_atom(value)
  end

  defp normalize_filter_element(%{type: "checkbox"}, value) do
    String.to_existing_atom(value)
  end

  defp normalize_filter_element(_, value), do: value
end

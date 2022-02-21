defmodule MyAppWeb.ResourceDataTable do
  use MyAppWeb, :live_component

  # alias MyAppWeb.Session
  import MyAppWeb.Paginator
  import MyAppWeb.Form

  @default_pagination_page_size 10

  def mount(socket) do
    {:ok, socket, temporary_assigns: [results: nil]}
  end

  def update(assigns, socket) do
    IO.inspect("UPDATE CALLED")

    socket =
      socket
      |> assign(assigns)
      # Default values for optional assigns
      |> assign_new(:class, fn -> nil end)
      |> assign_new(:action, fn -> :data_table end)

      # Default optional slots
      |> assign_new(:pagination, fn -> nil end)
      |> assign_new(:filter, fn -> nil end)
      |> assign_new(:sort, fn -> nil end)

      # assign plugins
      |> assign_filter_plugin()
      |> assign_sort_plugin()

      # |> assign_session_keys()

      # assign the results
      |> assign_results()

    {:ok, socket}
  end

  defp assign_filter_plugin(%{assigns: %{filter: nil}} = socket) do
    assign(socket, applied_filter: nil)
  end

  defp assign_filter_plugin(%{assigns: %{filter: filter_slots}} = socket) do
    applied_filter =
      Map.new(filter_slots, fn filter_slot ->
        {filter_slot.field, filter_default(filter_slot)}
      end)

    assign(socket, applied_filter: applied_filter)
  end

  defp filter_default(%{default: default}), do: default
  defp filter_default(%{type: "checkbox"}), do: false
  defp filter_default(%{type: "text"}), do: ""
  defp filter_default(_), do: nil

  defp assign_sort_plugin(%{assigns: %{sort: nil}} = socket) do
    assign(socket, applied_sort: nil)
  end

  defp assign_sort_plugin(%{assigns: %{sort: [first_sort_slot | _] = sort_slots}} = socket) do
    sort_options =
      sort_slots
      |> Enum.with_index()
      |> Enum.map(fn {sort_slot, index} -> {sort_slot.label, index} end)

    socket
    |> assign(applied_sort: first_sort_slot.sort)
    |> assign(applied_sort_index: 0)
    |> assign(sort_select_options: sort_options)
  end

  def render(assigns) do
    ~H"""
    <div class={@class}>
      <%= if @filter || @sort do %>
        <div class="py-2 px-5 bg-white flex flex-col sm:flex-row sm:items-center gap-6">
          <%= if @filter do %>
            <.form
              let={form}
              for={:filter}
              phx-change="filter"
              phx-submit="filter"
              phx-target={@myself}
              class="flex flex-col sm:flex-row sm:items-center gap-6"
            >
              <%= for filter <- @filter do %>
                <.filter_control filter={filter} form={form} value={@applied_filter[filter.field]} />
              <% end %>
            </.form>
          <% end %>
          <%= if @sort do %>
            <.form
              let={form}
              for={:sort}
              phx-change="sort"
              phx-submit="sort"
              phx-target={@myself}
              class="w-64"
            >
              <%= select form, :sort, @sort_select_options, value: @applied_sort_index %>
            </.form>
          <% end %>
        </div>
      <% end %>
      <%= render_slot(@inner_block, @results) %>
      <%= if @pagination do %>
        <.paginator
          offset={@page.offset}
          limit={@page.limit}
          count={@page.count}
          size={3}
          change_page="change_page"
          change_page_target={@myself}
        />
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
      |> build_query(
        socket.assigns.applied_filter,
        socket.assigns.applied_sort,
        socket.assigns.action
      )
      |> socket.assigns.api.read!()

    assign(socket, results: results)
  end

  defp assign_results(%{assigns: %{pagination: [pagination | _]}} = socket) do
    # page_no = Session.get(socket.assigns.session_id, socket.assigns.session_key_page, 1)
    page_no = 1

    page_size = pagination[:page_size] || @default_pagination_page_size
    offset = (page_no - 1) * page_size

    {page, results} =
      socket.assigns.resource
      |> build_query(
        socket.assigns.applied_filter,
        socket.assigns.applied_sort,
        socket.assigns.action
      )
      |> socket.assigns.api.read!(page: [limit: page_size, count: true, offset: offset])
      |> extract_results()

    assign(socket, page: page, results: results)
  end

  defp build_query(resource, filter, sort, action) do
    resource
    |> Ash.Query.new()
    |> add_filter(filter)
    |> add_sort(sort)
    |> Ash.Query.for_read(action)
  end

  defp add_filter(query, nil), do: query

  defp add_filter(query, applied_filter) do
    Ash.Query.set_argument(query, :filter, applied_filter)
  end

  defp add_sort(query, nil), do: query

  defp add_sort(query, applied_sort) do
    Ash.Query.sort(query, applied_sort)
  end

  def handle_event("change_page", %{"page" => page_no}, socket) do
    page_no = String.to_integer(page_no)

    {page, results} =
      socket.assigns.page
      |> socket.assigns.api.page!(page_no)
      |> extract_results()

    # Session.set(socket.assigns.session_id, socket.assigns.session_key_page, page_no)

    {:noreply, assign(socket, page: page, results: results)}
  end

  def handle_event("filter", %{"filter" => filter}, socket) do
    filter = normalize_filter_params(filter, socket.assigns.filter)

    socket =
      socket
      |> assign(applied_filter: filter)
      |> assign_results()

    {:noreply, socket}
  end

  def handle_event("sort", %{"sort" => sort}, socket) do
    sort_index = String.to_integer(sort["sort"])

    sort =
      socket.assigns.sort
      |> Enum.at(sort_index, %{})
      |> Map.get(:sort)

    socket =
      socket
      |> assign(applied_sort: sort)
      |> assign(applied_sort_index: sort_index)
      |> assign_results()

    {:noreply, socket}
  end

  defp extract_results(page) do
    results = page.results
    page = Map.put(page, :results, [])
    {page, results}
  end

  defp normalize_filter_params(applied_filter, filter_configs) do
    applied_filter
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

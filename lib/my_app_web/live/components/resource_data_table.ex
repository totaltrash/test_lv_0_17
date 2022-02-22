defmodule MyAppWeb.ResourceDataTable do
  use MyAppWeb, :live_component

  alias MyAppWeb.Session
  import MyAppWeb.Paginator
  import MyAppWeb.Form

  @default_pagination_page_size 10

  def mount(socket) do
    {:ok, socket, temporary_assigns: [results: nil]}
  end

  def update(assigns, socket) do
    # IO.inspect("UPDATE CALLED")

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
      |> assign_new(:session, fn -> nil end)

      # assign plugins
      |> assign_filter_plugin()
      |> assign_sort_plugin()
      |> assign_pagination_plugin()
      |> assign_session_plugin()

      # assign the results
      |> assign_results()

    {:ok, socket}
  end

  defp assign_pagination_plugin(%{assigns: %{pagination: nil}} = socket) do
    socket
  end

  defp assign_pagination_plugin(%{assigns: %{pagination: [pagination_slot | _]}} = socket) do
    page_no = get_session(socket.assigns.session, :page, 1)
    page_size = pagination_slot[:page_size] || @default_pagination_page_size

    socket
    |> assign(page_no: page_no)
    |> assign(page_size: page_size)
  end

  defp assign_filter_plugin(%{assigns: %{filter: nil}} = socket) do
    assign(socket, applied_filter: nil)
  end

  defp assign_filter_plugin(%{assigns: %{filter: filter_slots}} = socket) do
    applied_filter =
      get_session(socket.assigns.session, :filter, nil) ||
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

  defp assign_sort_plugin(%{assigns: %{sort: sort_slots}} = socket) do
    sort_options =
      sort_slots
      |> Enum.with_index()
      |> Enum.map(fn {sort_slot, index} -> {sort_slot.label, index} end)

    sort_index = get_session(socket.assigns.session, :sort, 0)
    sort_slot = Enum.at(sort_slots, sort_index, %{})

    socket
    |> assign(sort_select_options: sort_options)
    |> assign(applied_sort_index: sort_index)
    |> assign(applied_sort: sort_slot[:sort])
  end

  defp assign_session_plugin(%{assigns: %{session: nil}} = socket) do
    socket
  end

  defp assign_session_plugin(%{assigns: %{session: [session | _]}} = socket) do
    socket
    |> assign(session_id: session.id)
    |> assign(session_key_filter: session_key(session.key, :filter))
    |> assign(session_key_sort: session_key(session.key, :sort))
    |> assign(session_key_page: session_key(session.key, :page))
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

  defp assign_results(%{assigns: %{pagination: [_pagination | _]}} = socket) do
    page_no = socket.assigns.page_no
    page_size = socket.assigns.page_size
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

  defp add_filter(query, filter) do
    Ash.Query.set_argument(query, :filter, filter)
  end

  defp add_sort(query, nil), do: query

  defp add_sort(query, sort) do
    Ash.Query.sort(query, sort)
  end

  defp extract_results(page) do
    results = page.results
    page = Map.put(page, :results, [])
    {page, results}
  end

  defp assign_page_no(%{assigns: %{page_no: _}} = socket, page_no) do
    set_session(socket.assigns.session, :page, page_no)
    assign(socket, :page_no, page_no)
  end

  defp assign_page_no(socket, _page_no), do: socket

  #
  # Render and functional components
  # ================================
  #
  def render(assigns) do
    ~H"""
    <div class={@class}>
      <%= if @filter || @sort do %>
        <div class="py-2 px-4 sm:px-5 bg-white flex flex-col md:flex-row md:items-center gap-1 md:gap-5 lg:gap-8">
          <%= if @filter do %>
            <div class="flex flex-col">
              <span class="text-sm text-gray-500 font-medium">Filter</span>
              <.form
                id={"#{@id}_filter_form"}
                let={form}
                for={:filter}
                phx-change="filter"
                phx-submit="filter"
                phx-target={@myself}
                class="flex flex-col md:flex-row md:items-center gap-1 md:gap-3 lg:gap-5"
              >
                <%= for filter <- @filter do %>
                  <.filter_control
                    filter={filter}
                    form={form}
                    value={@applied_filter[filter.field]}
                    myself={@myself}
                  />
                <% end %>
              </.form>
            </div>
          <% end %>
          <%= if @sort do %>
            <div class="flex flex-col">
              <span class="text-sm text-gray-500 font-medium">Sort</span>
              <.form
                id={"#{@id}_sort_form"}
                let={form}
                for={:sort}
                phx-change="sort"
                phx-submit="sort"
                phx-target={@myself}
                class="md:w-56"
              >
                <%= select form, :sort, @sort_select_options, value: @applied_sort_index %>
              </.form>
            </div>
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
        placeholder={@filter[:placeholder] || nil}
      />
    """
  end

  defp filter_control(%{filter: %{type: "checkbox"}} = assigns) do
    assigns =
      assigns
      |> assign_new(:label, fn -> assigns.filter[:label] || nil end)

    ~H"""
      <div class="flex flex-row items-center gap-2 py-2">
        <%= checkbox @form, @filter.field, value: @value %>
        <%= if @label do %>
          <%= label @form, @filter.field, @label %>
        <% end %>
      </div>
    """
  end

  defp filter_control(%{filter: %{type: "custom"}} = assigns) do
    ~H"""
      <div>
        <%= render_slot(@filter, %{form: @form, field: @filter.field, value: @value}) %>
      </div>
    """
  end

  #
  # Event Handlers
  # ==============
  #
  def handle_event("change_page", %{"page" => page_no}, socket) do
    page_no = String.to_integer(page_no)

    {page, results} =
      socket.assigns.page
      |> socket.assigns.api.page!(page_no)
      |> extract_results()

    set_session(socket.assigns.session, :page, page_no)

    {:noreply, assign(socket, page: page, page_no: page_no, results: results)}
  end

  def handle_event("filter", %{"filter" => filter}, socket) do
    filter = normalize_filter_params(filter, socket.assigns.filter)

    socket =
      socket
      |> assign(applied_filter: filter)
      |> assign_page_no(1)
      |> assign_results()

    set_session(socket.assigns.session, :filter, filter)

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
      |> assign_page_no(1)
      |> assign_results()

    set_session(socket.assigns.session, :sort, sort_index)

    {:noreply, socket}
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

  #
  # Session Management
  # ==================
  #
  # The session can be used to store filter, sort and current page. The session
  # is defined in a session slot, and is optional.
  #
  defp session_key(key, :filter), do: key <> "_filter"
  defp session_key(key, :sort), do: key <> "_sort"
  defp session_key(key, :page), do: key <> "_page"

  defp set_session(nil, _key_type, _value), do: nil

  defp set_session([session_slot | _], key_type, value) do
    Session.set(session_slot.id, session_key(session_slot.key, key_type), value)
  end

  defp get_session(nil, _key_type, default), do: default

  defp get_session([session_slot | _], key_type, default) do
    Session.get(session_slot.id, session_key(session_slot.key, key_type), default)
  end
end

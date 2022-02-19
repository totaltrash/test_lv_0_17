defmodule MyAppWeb.ResourceDataTablesLive do
  use MyAppWeb, :live_view

  import MyAppWeb.Page
  import MyAppWeb.Table
  import MyAppWeb.Form
  import MyAppWeb.ResourceDataTable.Components

  # def mount(_params, _session, socket) do
  #   socket = assign(socket, :messages, load_some_messages(socket))

  #   {:ok, socket, temporary_assigns: [messages: []]}
  # end

  def render(assigns) do
    ~H"""
    <.wrapper current_menu="resource_data_tables" title="Resource Data Tables">
      <.h1>Simple</.h1>
      <.live_component
        module={MyAppWeb.ResourceDataTable}
        id="simple_events_table"
        api={MyApp.Calendar}
        resource={MyApp.Calendar.Event}
        let={items}
        class="mb-8"
      >
        <.data_table items={items}>
          <:col let={item} label="Start Time" th_class="w-1/4">
            <.format_datetime datetime={item.start_on} />
          </:col>
          <:col let={item} label="Title">
            <%= item.title %>
          </:col>
        </.data_table>
      </.live_component>

      <.h1>Pagination</.h1>
      <.live_component
        module={MyAppWeb.ResourceDataTable}
        id="paginated_events_table"
        api={MyApp.Calendar}
        resource={MyApp.Calendar.Event}
        let={items}
        class="mb-8"
      >
        <.data_table items={items}>
          <:col let={item} label="Start Time" th_class="w-1/4">
            <.format_datetime datetime={item.start_on} />
          </:col>
          <:col let={item} label="Title">
            <%= item.title %>
          </:col>
        </.data_table>
        <:pagination />
      </.live_component>

      <.h1>Filter and Pagination</.h1>
      <.live_component
        module={MyAppWeb.ResourceDataTable}
        id="filter_events_table"
        api={MyApp.Calendar}
        resource={MyApp.Calendar.Event}
        let={items}
        class="mb-8"
      >
        <.data_table items={items}>
          <:col let={item} label="Start Time" th_class="w-1/4">
            <.format_datetime datetime={item.start_on} />
          </:col>
          <:col let={item} label="Title">
            <%= item.title %>
          </:col>
        </.data_table>
        <:filter field={:keyword} type="text" initial="" placeholder="Filter" />
        <:filter field={:active} type="checkbox" initial={true} label="Active?" />
        <:filter let={ctx} field={:some_custom} type="custom" normalize="integer">
          <%= number_input ctx.form, ctx.field, value: ctx.value, class: "w-64" %>
        </:filter>
        <:pagination page_size={1} let={ctx} empty_message="No events found">
          Showing <%= ctx.start %> to <%= ctx.end %> of <%= ctx.total %> events
        </:pagination>
        <:session key="some_key" id={@session_id} />
        <:sort />
      </.live_component>
    </.wrapper>
    """
  end

  # <.live_component
  #   module={MyAppWeb.ResourceDataTable}
  #   id="events_data_table"
  #   session_key="contact_index"
  #   session_id={@session_id}
  #   api={MyApp.Calendar}
  #   resource={MyApp.Calendar.Event}
  #   let={items}
  #   page_size={10}
  # >
  #   <.data_table items={items}>
  #     <:col let={item} label="Start Time" th_class="w-1/4">
  #       <.format_datetime datetime={item.start_on} />
  #     </:col>
  #     <:col let={item} label="Title">
  #       <%= item.title %>
  #     </:col>
  #   </.data_table>
  # </.live_component>
end

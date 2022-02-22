defmodule MyAppWeb.ResourceDataTablesLive do
  use MyAppWeb, :live_view

  import MyAppWeb.Page
  import MyAppWeb.Table
  # import MyAppWeb.Form
  # import MyAppWeb.ResourceDataTable.Components

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

      <.h1>Filter</.h1>
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

        <:filter field={:keyword} type="text" placeholder="Filter" />
        <:filter field={:active} type="checkbox" default={true} label="Active?" />
      </.live_component>

      <.h1>Sort</.h1>
      <.live_component
        module={MyAppWeb.ResourceDataTable}
        id="sort_events_table"
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

        <:sort label="Title Asc" sort={[title: :asc]} />
        <:sort label="Title Desc" sort={[title: :desc]} />
        <:sort label="Start time Asc" sort={[start_on: :asc]} />
        <:sort label="Start time Desc" sort={[start_on: :desc]} />
      </.live_component>

      <.h1>The Lot</.h1>
      <.live_component
        module={MyAppWeb.ResourceDataTable}
        id="the_lot_events_table"
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

        <:filter field={:keyword} type="text" placeholder="Filter" />
        <:filter field={:other} type="text" placeholder="Other" label="Label" />
        <:filter field={:active} type="checkbox" default={true} label="Active?" />
        <:filter field={:some_custom} type="custom" let={ctx} normalize="integer">
          <%= number_input ctx.form, ctx.field, value: ctx.value, autocomplete: "off", class: "w-64" %>
        </:filter>

        <:sort label="Title Asc" sort={[title: :asc]} />
        <:sort label="Title Desc" sort={[title: :desc]} />
        <:sort label="Start time Asc" sort={[start_on: :asc]} />
        <:sort label="Start time Desc" sort={[start_on: :desc]} />

        <:pagination page_size={1} />

        <:session key="resource_data_table_the_lot" id={@session_id} />
      </.live_component>
    </.wrapper>
    """
  end
end

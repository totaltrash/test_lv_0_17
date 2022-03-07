defmodule MyAppWeb.ResourceLoaderLive do
  use MyAppWeb, :live_view

  import IFixComponents.Page
  import IFixComponents.Table

  def render(assigns) do
    ~H"""
    <.wrapper current_menu="resource_loader" title="Resource Loader">
      <.h1>Simple</.h1>
      <.live_component
        module={IFixComponents.ResourceLoader}
        id="simple_events_loader"
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
        module={IFixComponents.ResourceLoader}
        id="paginated_events_loader"
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
        module={IFixComponents.ResourceLoader}
        id="filter_events_loader"
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

        <:filter field={:keyword} type="text" placeholder="Keyword" />
        <:filter field={:active} type="checkbox" default={true} label="Active?" />
      </.live_component>

      <.h1>Sort</.h1>
      <.live_component
        module={IFixComponents.ResourceLoader}
        id="sort_events_loader"
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

      <.h1>The Lot and Session Storage</.h1>
      <.live_component
        module={IFixComponents.ResourceLoader}
        id="the_lot_events_loader"
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

        <:filter field={:keyword} type="text" placeholder="Keyword" />
        <:filter field={:other} type="text" placeholder="Other" />
        <:filter field={:some_custom} type="custom" let={ctx} normalize="integer">
          <%= number_input ctx.form, ctx.field, value: ctx.value, autocomplete: "off", placeholder: "Custom" %>
        </:filter>
        <:filter field={:active} type="checkbox" default={true} label="Active?" />

        <:sort label="Title Asc" sort={[title: :asc]} />
        <:sort label="Title Desc" sort={[title: :desc]} />
        <:sort label="Start time Asc" sort={[start_on: :asc]} />
        <:sort label="Start time Desc" sort={[start_on: :desc]} />

        <:pagination size={1} />

        <:session key="resource_loader_the_lot" id={@session_id} />
      </.live_component>
    </.wrapper>
    """
  end
end

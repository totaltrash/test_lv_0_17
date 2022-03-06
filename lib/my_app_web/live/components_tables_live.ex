defmodule MyAppWeb.ComponentsTablesLive do
  use MyAppWeb, :live_view

  import IFixComponents.Page
  import IFixComponents.Table
  import MyAppWeb.ComponentsLive.Components

  def mount(_, _session, socket) do
    socket =
      socket
      |> assign(data_table_items: [%{id: 1, name: "Some Name"}])

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.wrapper current_menu="components" title="Components">
      <.components_container>
        <.components_nav current="tables" />
      </.components_container>
      <.h1>Simple Table</.h1>
      <.table class="mb-8">
        <.head>
          <.row>
            <.th class="w-1/4">Heading 1</.th>
            <.th>Heading 2</.th>
          </.row>
        </.head>
        <.body>
          <.row>
            <.td>Row 1</.td>
            <.td>Something here</.td>
          </.row>
          <.row class="bg-red-700 text-white">
            <.td>Row 2</.td>
            <.td>Something here</.td>
          </.row>
        </.body>
      </.table>
      <.h1>Data Table</.h1>
      <.data_table items={@data_table_items} class="mb-8">
        <:col let={item} label="ID" th_class="w-1/4">
          <%= item.id %>
        </:col>
        <:col let={item} label="Name">
          <%= item.name %>
        </:col>
      </.data_table>
      <.h1>Empty Data Table</.h1>
      <.data_table items={[]} class="mb-8">
        <:col let={item} label="ID" th_class="w-1/4">
          <%= item.id %>
        </:col>
        <:col let={item} label="Name">
          <%= item.name %>
        </:col>
      </.data_table>
    </.wrapper>
    """
  end
end

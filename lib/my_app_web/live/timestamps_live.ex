defmodule MyAppWeb.TimestampsLive do
  use MyAppWeb, :live_view

  import MyAppWeb.Page
  import MyAppWeb.Modal
  import MyAppWeb.Form

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign_events()
      |> assign(:event, nil)

    {:ok, socket}
  end

  defp assign_events(socket) do
    events =
      MyApp.Calendar.Event
      |> MyApp.Calendar.read!()

    assign(socket, events: events)
  end

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, params, socket.assigns.live_action)}
  end

  defp apply_action(socket, params, :show) do
    event =
      MyApp.Calendar.Event
      |> MyApp.Calendar.get!(params["id"])

    assign(socket, event: event)
  end

  defp apply_action(socket, params, :edit) do
    event = MyApp.Calendar.get!(MyApp.Calendar.Event, params["id"])
    form = AshPhoenix.Form.for_update(event, :update, as: "event", api: MyApp.Calendar)
    assign(socket, event: event, form: form)
  end

  defp apply_action(socket, _, :index) do
    socket
  end

  def render(assigns) do
    ~H"""
    <.wrapper current_menu="timestamps" title="Timestamps">
      <h3 class="text-xl font-bold">Events</h3>
      <.events_list events={@events}/>
      <%= if connected?(@socket) do %>
        <%= if @live_action == :show do %>
          <.modal heading={@event.title} close="show_modal_close" icon="calendar">
            <.timestamp_detail timestamp={@event.start_on} />
            <:buttons>
              <.modal_button label="OK" color="primary" click="show_modal_close" />
            </:buttons>
          </.modal>
        <% end %>
        <%= if @live_action == :edit do %>
          <.form_modal heading="Edit Event" let={f} form={@form} form_submit="form_modal_submit" cancel="form_modal_close">
            <.field_row>
              <%= label f, :title %>
              <%= text_input f, :title, autocomplete: "off" %>
              <%= error_tag f, :title  %>
            </.field_row>
            <.field_row>
              <%= label f, :start_on %>
              <%= datetime_local_input f, :start_on, value: convert_to_local(input_value(f, :start_on)), class: "sm:w-1/2" %>
              <%= error_tag f, :start_on  %>
            </.field_row>
          </.form_modal>
        <% end %>
      <% end %>
    </.wrapper>
    """
  end

  defp events_list(assigns) do
    ~H"""
    <%= for event <- @events do %>
      <div>
        <%= live_patch "Show", to: Routes.timestamps_path(MyAppWeb.Endpoint, :show, event.id), class: "font-bold text-sky-600 hover:text-sky-700" %>
        <%= live_patch "Edit", to: Routes.timestamps_path(MyAppWeb.Endpoint, :edit, event.id), class: "font-bold text-sky-600 hover:text-sky-700" %>
        <%= event.title %>: <.format_datetime datetime={event.start_on} />
      </div>
    <% end %>
    """
  end

  defp convert_to_local(nil) do
    nil
  end

  defp convert_to_local(datetime) do
    Timex.Timezone.convert(datetime, "Australia/Melbourne")
  end

  defp timestamp_detail(%{timestamp: timestamp} = assigns) do
    format = "%d/%m/%Y %H:%M:%S"
    timestamp_au = Timex.Timezone.convert(timestamp, "Australia/Melbourne")
    timestamp_uk = Timex.Timezone.convert(timestamp, "Europe/London")

    assigns =
      assigns
      |> assign(:timestamp_utc, timestamp)
      |> assign(:formatted_utc, Calendar.strftime(timestamp, format))
      |> assign(:timestamp_au, timestamp_au)
      |> assign(:formatted_au, Calendar.strftime(timestamp_au, format))
      |> assign(:timestamp_uk, timestamp_uk)
      |> assign(:formatted_uk, Calendar.strftime(timestamp_uk, format))

    ~H"""
      <ul class="">
        <li>timestamp_utc: <%= @timestamp_utc %></li>
        <li class="font-bold text-gray-800">formatted_utc: <%= @formatted_utc %></li>
        <li>timestamp_au: <%= @timestamp_au %></li>
        <li class="font-bold text-gray-800">formatted_au: <%= @formatted_au %></li>
        <li>timestamp_uk: <%= @timestamp_uk %></li>
        <li class="font-bold text-gray-800">formatted_uk: <%= @formatted_uk %></li>
      </ul>
    """
  end

  def handle_event("form_modal_submit", %{"event" => params}, socket) do
    params = Map.put(params, "start_on", local_param_to_utc(params["start_on"]))

    case AshPhoenix.Form.submit(socket.assigns.form, params: params) do
      {:ok, _} ->
        {:noreply,
         socket
         |> add_toast(:info, "Submitted")
         |> push_redirect(to: Routes.timestamps_path(socket, :index))}

      {:error, %AshPhoenix.Form{} = form} ->
        {:noreply, assign(socket, form: form)}
    end
  end

  def handle_event("form_modal_close", _, socket) do
    {:noreply, push_patch(socket, to: Routes.timestamps_path(socket, :index))}
  end

  def handle_event("show_modal_close", _, socket) do
    {:noreply, push_patch(socket, to: Routes.timestamps_path(socket, :index))}
  end

  defp format_datetime(assigns) do
    ~H[<%= Timex.Timezone.convert(@datetime, "Australia/Melbourne") |> Calendar.strftime("%d/%m/%Y %H:%M:%S") %>]
  end

  defp local_param_to_utc("") do
    ""
  end

  defp local_param_to_utc(datetime) do
    datetime
    |> Timex.parse!("%Y-%m-%dT%H:%M", :strftime)
    |> Timex.to_datetime("Australia/Melbourne")
    |> Timex.Timezone.convert("Etc/UTC")
    |> Timex.format!("%Y-%m-%dT%H:%M", :strftime)
  end
end

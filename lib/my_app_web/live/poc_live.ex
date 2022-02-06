defmodule MyAppWeb.PocLive do
  use MyAppWeb, :live_view

  @topic "messages"

  import MyAppWeb.Page
  import MyAppWeb.Modal
  import MyAppWeb.Button
  import MyAppWeb.Form

  def mount(_, _session, socket) do
    MyAppWeb.Endpoint.subscribe(@topic)
    {:ok, socket}
  end

  def render(assigns) do
    button_base_classes =
      "flex items-center justify-center px-4 py-2 border border-transparent text-base font-medium rounded text-white md:py-3 md:text-lg md:px-6"

    ~H"""
    <.wrapper current_menu="poc" title="POC">
      <h1 class="text-2xl font-medium mb-2">Modals</h1>
      <div class="flex flex-wrap items-center gap-4">
      <%= live_patch("Alert Modal", to: Routes.poc_path(MyAppWeb.Endpoint, :show_alert_modal), class: "#{button_base_classes} bg-indigo-600 hover:bg-indigo-700") %>
      <%= live_patch("Confirm Modal", to: Routes.poc_path(MyAppWeb.Endpoint, :show_confirm_modal), class: "#{button_base_classes} bg-indigo-600 hover:bg-indigo-700") %>
      <%= live_patch("Form Modal", to: Routes.poc_path(MyAppWeb.Endpoint, :show_form_modal), class: "#{button_base_classes} bg-indigo-600 hover:bg-indigo-700") %>
      <%= live_patch("Custom Modal", to: Routes.poc_path(MyAppWeb.Endpoint, :show_custom_modal), class: "#{button_base_classes} bg-indigo-600 hover:bg-indigo-700") %>

        <.button
          variant={:danger}
          href={Routes.poc_path(MyAppWeb.Endpoint, :show_confirm_modal)}
          data-phx-link="patch"
          data-phx-link-state="push">Show Modal (Button Component)</.button>
      </div>
      <h1 class="text-2xl font-medium mt-8 mb-2">Flashes</h1>
      <div class="flex flex-wrap items-center gap-4">
        <button phx-click="add_flash" phx-value-type={:error} class={"#{button_base_classes} bg-red-600 hover:bg-red-700"}>
          Add Flash
        </button>
        <button phx-click="add_flash" phx-value-type={:info} class={"#{button_base_classes} bg-blue-600 hover:bg-blue-700"}>
          Add Flash
        </button>
        <button phx-click="add_flash" phx-value-type={:success} class={"#{button_base_classes} bg-green-600 hover:bg-green-700"}>
          Add Flash
        </button>
      </div>
      <h1 class="text-2xl font-medium mt-8 mb-2">Toasts</h1>
      <div class="flex flex-wrap items-center gap-4">
        <button phx-click="add_toast" phx-value-type={:error} class={"#{button_base_classes} bg-red-600 hover:bg-red-700"}>
          Add Toast
        </button>
        <button phx-click="add_toast" phx-value-type={:info} class={"#{button_base_classes} bg-blue-600 hover:bg-blue-700"}>
          Add Toast
        </button>
        <button phx-click="add_toast" phx-value-type={:success} class={"#{button_base_classes} bg-green-600 hover:bg-green-700"}>
          Add Toast
        </button>
        <button phx-click="add_toast_and_patch" phx-value-type={:success} class={"#{button_base_classes} bg-green-500 hover:bg-green-600"}>
          Add Toast and Patch
        </button>
        <button phx-click="add_toast_and_redirect" phx-value-type={:success} class={"#{button_base_classes} bg-green-400 hover:bg-green-500"}>
          Add Toast and Redirect
        </button>
      </div>
      <h1 class="text-2xl font-medium mt-8 mb-2">Messages</h1>
      <div class="flex flex-wrap items-center gap-4">
        <button phx-click="send_local_message" class={"#{button_base_classes} bg-yellow-600 hover:bg-yellow-700"}>
          Send Local Message
        </button>
        <button phx-click="send_global_message" class={"#{button_base_classes} bg-yellow-500 hover:bg-yellow-600"}>
          Send Global Message
        </button>
      </div>
      <%= if connected?(@socket) do %>
        <%= if @live_action == :show_alert_modal do %>
          <.alert_modal heading="Alert Modal" ok="alert_modal_ok">
            Yep, that happened
          </.alert_modal>
        <% end %>
        <%= if @live_action == :show_confirm_modal do %>
          <.confirm_modal heading="Confirm Modal" ok="confirm_modal_ok" cancel="confirm_modal_cancel">
            Hey, are you sure?
          </.confirm_modal>
        <% end %>
        <%= if @live_action == :show_form_modal do %>
          <.form_modal heading="Form Modal" let={f} form={@form} form_submit="form_modal_submit" cancel="form_modal_cancel">
            <.field_row>
              <%= label f, :title %>
              <%= text_input f, :title, autocomplete: "off" %>
              <%= error_tag f, :title  %>
            </.field_row>
          </.form_modal>
        <% end %>
        <%= if @live_action == :show_custom_modal do %>
          <.modal heading="Custom Modal" close="modal_close" icon="exclamation" icon_color="bg-red-100 text-red-700">
            Hey, are you sure?
            <:buttons>
              <.modal_button label="Submit" variant="danger" click="modal_submit" />
              <.modal_button label="Cancel" click="modal_close" />
            </:buttons>
          </.modal>
        <% end %>
      <% end %>
    </.wrapper>
    """
  end

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, params, socket.assigns.live_action)}
  end

  defp apply_action(socket, _params, :show_form_modal) do
    assign(socket, form: :form)
  end

  defp apply_action(socket, _, _) do
    socket
  end

  def handle_event("modal_submit", _, socket) do
    socket =
      socket
      |> add_toast(:success, "Submitted modal")
      |> push_patch(to: Routes.poc_path(socket, :index))

    {:noreply, socket}
  end

  def handle_event("modal_close", _, socket) do
    socket =
      socket
      |> add_toast(:info, "Closed modal")
      |> push_patch(to: Routes.poc_path(socket, :index))

    {:noreply, socket}
  end

  def handle_event("add_flash", %{"type" => type}, socket) do
    socket =
      socket
      |> put_flash(type, "Hello #{to_string(type)} flash")

    {:noreply, socket}
  end

  def handle_event("add_toast", %{"type" => type}, socket) do
    socket =
      socket
      |> add_toast(type, "Hello #{to_string(type)} toast")

    {:noreply, socket}
  end

  def handle_event("add_toast_and_patch", %{"type" => type}, socket) do
    socket =
      socket
      |> add_toast(type, "Hello toast and patch")
      |> push_patch(to: Routes.poc_path(socket, :index))

    {:noreply, socket}
  end

  def handle_event("add_toast_and_redirect", %{"type" => _type}, socket) do
    socket =
      socket
      |> add_toast(:error, "Hello toast and redirect")
      |> push_redirect(to: Routes.poc_path(socket, :index))

    {:noreply, socket}
  end

  def handle_event("alert_modal_ok", _, socket) do
    socket =
      socket
      |> push_patch(to: Routes.poc_path(socket, :index))

    {:noreply, socket}
  end

  def handle_event("confirm_modal_ok", _, socket) do
    socket =
      socket
      |> add_toast(:success, "Wow, you confirmed, stand by...")
      |> push_patch(to: Routes.poc_path(socket, :index))

    {:noreply, socket}
  end

  def handle_event("confirm_modal_cancel", _, socket) do
    socket =
      socket
      |> add_toast(:info, "Cancelled, that's a good call")
      |> push_patch(to: Routes.poc_path(socket, :index))

    {:noreply, socket}
  end

  def handle_event("form_modal_cancel", _, socket) do
    socket =
      socket
      |> add_toast(:info, "Cancelled form modal")
      |> push_patch(to: Routes.poc_path(socket, :index))

    {:noreply, socket}
  end

  def handle_event("form_modal_submit", %{"form" => form}, socket) do
    IO.inspect(form)

    socket =
      socket
      |> add_toast(:info, "Submitted form modal")
      |> push_patch(to: Routes.poc_path(socket, :index))

    {:noreply, socket}
  end

  def handle_event("send_local_message", _, socket) do
    send(self(), :local_message)

    {:noreply, socket}
  end

  def handle_event("send_global_message", _, socket) do
    MyAppWeb.Endpoint.broadcast(@topic, "greeting", %{sender: inspect(self()), message: "whatup"})

    {:noreply, socket}
  end

  def handle_info(:local_message, socket) do
    socket =
      socket
      |> add_toast(:success, "Local message received")
      |> push_patch(to: Routes.poc_path(socket, :index))

    {:noreply, socket}
  end

  def handle_info(
        %Phoenix.Socket.Broadcast{topic: @topic, event: "greeting", payload: payload} = _info,
        socket
      ) do
    # IO.inspect(info)

    socket =
      socket
      |> add_toast(
        :success,
        "Global message received: #{payload.message}, from #{payload.sender}"
      )

    {:noreply, socket}
  end
end

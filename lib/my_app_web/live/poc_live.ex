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
    ~H"""
    <.wrapper current_menu="poc" title="POC">
      <h1 class="text-2xl font-medium mb-2">Modals</h1>
      <div class="flex flex-wrap items-center gap-4">
        <.button type="link" variant="primary" href={Routes.poc_path(MyAppWeb.Endpoint, :show_alert_modal)} label="Alert Modal" />
        <.button type="link" variant="primary" href={Routes.poc_path(MyAppWeb.Endpoint, :show_confirm_modal)} label="Confirm Modal" />
        <.button type="link" variant="primary" href={Routes.poc_path(MyAppWeb.Endpoint, :show_form_modal)} label="Form Modal" />
        <.button type="link" variant="primary" href={Routes.poc_path(MyAppWeb.Endpoint, :show_custom_modal)} label="Custom Modal" />
      </div>
      <h1 class="text-2xl font-medium mt-8 mb-2">Flashes</h1>
      <div class="flex flex-wrap items-center gap-4">
        <.button click="add_flash" label="Add Flash" phx-value-type={:error} variant="danger" />
        <.button click="add_flash" label="Add Flash" phx-value-type={:info} variant="primary" />
        <.button click="add_flash" label="Add Flash" phx-value-type={:success} variant={{:custom, "bg-green-600 hover:bg-green-700 text-white border-transparent focus:ring-green-700"}} />
      </div>
      <h1 class="text-2xl font-medium mt-8 mb-2">Toasts</h1>
      <div class="flex flex-wrap items-center gap-4">
        <.button click="add_toast" label="Add Toast" phx-value-type={:error} variant="danger" />
        <.button click="add_toast" label="Add Toast" phx-value-type={:info} variant="primary" />
        <.button click="add_toast" label="Add Toast" phx-value-type={:success} variant={{:custom, "bg-green-600 hover:bg-green-700 text-white border-transparent focus:ring-green-700"}} />
        <.button click="add_toast_and_patch" label="Add Toast and Patch" phx-value-type={:success} variant="primary" />
        <.button click="add_toast_and_redirect" label="Add Toast and redirect" phx-value-type={:success} variant="primary" />
      </div>
      <h1 class="text-2xl font-medium mt-8 mb-2">Messages</h1>
      <div class="flex flex-wrap items-center gap-4">
        <.button click="send_local_message" label="Send Local Message" variant="primary" />
        <.button click="send_global_message" label="Send Global Message" variant="primary" />
      </div>
      <h1 class="text-2xl font-medium mt-8 mb-2">Buttons</h1>
      <h2 class="text-lg font-medium text-gray-500 mt-2 mb-2">Links</h2>
      <div class="flex flex-wrap items-center gap-4">
        <.button
          type="link"
          href={Routes.poc_path(MyAppWeb.Endpoint, :show_alert_modal)}
          label="Label"
          variant="primary"
        />
        <.button
          type="link"
          href={Routes.poc_path(MyAppWeb.Endpoint, :show_alert_modal)}
          variant="primary"
        >Slot</.button>
        <.button
          type="link"
          variant={{:custom, "bg-green-600 hover:bg-green-700 text-white border-transparent focus:ring-green-700"}}
          href={Routes.poc_path(MyAppWeb.Endpoint, :show_alert_modal)}
          label="Custom Variant"
        />
      </div>
      <h2 class="text-lg font-medium text-gray-500 mt-2 mb-2">Buttons</h2>
      <div class="flex flex-wrap items-center gap-4">
        <.button click="button_click" label="Label" variant="primary" />
        <.button click="button_click" variant="primary">Slot</.button>
        <.button click="button_click" label="Custom Variant" variant={{:custom, "bg-green-600 hover:bg-green-700 text-white border-transparent focus:ring-green-700"}} />
      </div>
      <h2 class="text-lg font-medium text-gray-500 mt-2 mb-2">Submit</h2>
      <.form for={:form} phx-submit="form_submit" class="flex flex-wrap items-center gap-4">
        <.button type="submit" label="Label" variant="primary" />
        <.button type="submit" variant="primary">Slot</.button>
        <.button type="submit" label="Custom Variant" variant={{:custom, "bg-green-600 hover:bg-green-700 text-white border-transparent focus:ring-green-700"}} />
      </.form>
      <h2 class="text-lg font-medium text-gray-500 mt-2 mb-2">Sizes</h2>
      <div class="flex flex-wrap items-center gap-4">
        <.button click="button_click" label="Small (sm)" variant="primary" size="sm" />
        <.button click="button_click" label="Normal (md)" variant="primary" size="md" />
        <.button click="button_click" label="Large (lg)" variant="primary" size="lg" />
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
          <.modal heading="Custom Modal" close="custom_modal_close" icon="exclamation" icon_color="bg-red-100 text-red-700">
            Hey, are you sure?
            <:buttons>
              <.modal_button label="Do It" variant="danger" click="custom_modal_do_it" />
              <.modal_button label="Cancel" click="custom_modal_close" />
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

  def handle_event("custom_modal_do_it", _, socket) do
    socket =
      socket
      |> add_toast(:success, "Custom modal doing it")
      |> push_patch(to: Routes.poc_path(socket, :index))

    {:noreply, socket}
  end

  def handle_event("custom_modal_close", _, socket) do
    socket =
      socket
      |> add_toast(:info, "Custom modal closed")
      |> push_patch(to: Routes.poc_path(socket, :index))

    {:noreply, socket}
  end

  def handle_event("button_click", _, socket) do
    socket =
      socket
      |> add_toast(:info, "Button clicked")

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

  def handle_event("form_modal_submit", _params, socket) do
    socket =
      socket
      |> add_toast(:info, "Submitted form modal")
      |> push_patch(to: Routes.poc_path(socket, :index))

    {:noreply, socket}
  end

  def handle_event("form_submit", _params, socket) do
    socket =
      socket
      |> add_toast(:info, "Submitted form")
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
    socket =
      socket
      |> add_toast(
        :success,
        "Global message received: #{payload.message}, from #{payload.sender}"
      )

    {:noreply, socket}
  end
end

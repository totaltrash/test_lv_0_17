defmodule MyAppWeb.TodoLive do
  use MyAppWeb, :live_view

  @topic "messages"

  # on_mount MyAppWeb.InitAssigns
  alias MyAppWeb.Page
  alias MyAppWeb.Modal

  def mount(_, _session, socket) do
    MyAppWeb.Endpoint.subscribe(@topic)
    {:ok, socket}
  end

  def render(assigns) do
    button_base_classes =
      "flex items-center justify-center px-8 py-3 border border-transparent text-base font-medium rounded-md text-white md:py-4 md:text-lg md:px-10"

    ~H"""
    <Page.wrapper current_menu="todo" title="To Do">
      <div class="flex flex-wrap items-center gap-4">
        <%= live_patch("Show Modal", to: Routes.todo_path(MyAppWeb.Endpoint, :show_modal), class: "#{button_base_classes} bg-indigo-600 hover:bg-indigo-700") %>
        <button phx-click="add_flash" phx-value-type={:error} class={"#{button_base_classes} bg-red-600 hover:bg-red-700"}>
          Add Flash
        </button>
        <button phx-click="add_flash" phx-value-type={:info} class={"#{button_base_classes} bg-blue-600 hover:bg-blue-700"}>
          Add Flash
        </button>
        <button phx-click="add_flash" phx-value-type={:success} class={"#{button_base_classes} bg-green-600 hover:bg-green-700"}>
          Add Flash
        </button>

        <button phx-click="add_toast" phx-value-type={:error} class={"#{button_base_classes} bg-red-600 hover:bg-red-700"}>
          Add Toast
        </button>
        <button phx-click="add_toast" phx-value-type={:info} class={"#{button_base_classes} bg-blue-600 hover:bg-blue-700"}>
          Add Toast
        </button>
        <button phx-click="add_toast" phx-value-type={:success} class={"#{button_base_classes} bg-green-600 hover:bg-green-700"}>
          Add Toast
        </button>

        <button phx-click="send_local_message" class={"#{button_base_classes} bg-yellow-600 hover:bg-yellow-700"}>
          Send Local Message
        </button>
        <button phx-click="send_global_message" class={"#{button_base_classes} bg-yellow-500 hover:bg-yellow-600"}>
          Send Global Message
        </button>
      </div>
      <%= if @live_action == :show_modal do %>
        <Modal.confirm_modal heading="This could be dangerous" confirm="modal_confirm" cancel="modal_cancel">
          Hey, are you sure?
        </Modal.confirm_modal>
      <% end %>
    </Page.wrapper>
    """
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  def handle_event("add_flash", %{"type" => type}, socket) do
    socket =
      socket
      |> put_flash(type, "Hello #{to_string(type)} flash")

    {:noreply, socket}
  end

  def handle_event("add_toast", %{"type" => type}, socket) do
    # IO.inspect("HERE 1")
    # send(self(), {:add_toast, %{type: type, message: "BLAH"}})

    socket =
      socket
      |> add_toast(type, "Hello #{to_string(type)} toast")

    {:noreply, socket}
  end

  defp add_toast(socket, type, message) do
    send(self(), {:add_toast, %{type: type, message: message}})

    socket
  end

  def handle_event("modal_confirm", _, socket) do
    socket =
      socket
      |> put_flash(:success, "Wow, you confirmed, stand by...")
      |> push_patch(to: Routes.todo_path(socket, :index))

    {:noreply, socket}
  end

  def handle_event("modal_cancel", _, socket) do
    socket =
      socket
      |> put_flash(:info, "Cancelled, that's a good call")
      |> push_patch(to: Routes.todo_path(socket, :index))

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
      |> put_flash(:success, "Local message received")
      |> push_patch(to: Routes.todo_path(socket, :index))

    {:noreply, socket}
  end

  def handle_info(
        %Phoenix.Socket.Broadcast{topic: @topic, event: "greeting", payload: payload} = _info,
        socket
      ) do
    # IO.inspect(info)

    socket =
      socket
      |> put_flash(
        :success,
        "Global message received: #{payload.message}, from #{payload.sender}"
      )

    {:noreply, socket}
  end
end

defmodule MyAppWeb.TodoLive do
  use MyAppWeb, :live_view

  @topic "messages"

  alias MyAppWeb.Page
  alias MyAppWeb.Modal

  def mount(_, _session, socket) do
    MyAppWeb.Endpoint.subscribe(@topic)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <Page.wrapper current_menu="todo" title="To Do">
      <div class="flex items-center gap-4">
        <%= live_patch("Show Modal", to: Routes.todo_path(MyAppWeb.Endpoint, :show_modal), class: "flex items-center justify-center px-8 py-3 border border-transparent text-base font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 md:py-4 md:text-lg md:px-10") %>
        <button phx-click="add_flash" phx-value-type={:error} class="flex items-center justify-center px-8 py-3 border border-transparent text-base font-medium rounded-md text-white bg-red-600 hover:bg-red-700 md:py-4 md:text-lg md:px-10">
          Add Flash
        </button>
        <button phx-click="add_flash" phx-value-type={:info} class="flex items-center justify-center px-8 py-3 border border-transparent text-base font-medium rounded-md text-white bg-blue-600 hover:bg-blue-700 md:py-4 md:text-lg md:px-10">
          Add Flash
        </button>
        <button phx-click="add_flash" phx-value-type={:success} class="flex items-center justify-center px-8 py-3 border border-transparent text-base font-medium rounded-md text-white bg-green-600 hover:bg-green-700 md:py-4 md:text-lg md:px-10">
          Add Flash
        </button>
        <button phx-click="send_local_message" class="flex items-center justify-center px-8 py-3 border border-transparent text-base font-medium rounded-md text-white bg-yellow-600 hover:bg-yellow-700 md:py-4 md:text-lg md:px-10">
          Send Local Message
        </button>
        <button phx-click="send_global_message" class="flex items-center justify-center px-8 py-3 border border-transparent text-base font-medium rounded-md text-white bg-yellow-500 hover:bg-yellow-600 md:py-4 md:text-lg md:px-10">
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
    MyAppWeb.Endpoint.broadcast(@topic, "whatup from #{inspect(self())}!", %{})

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
        %Phoenix.Socket.Broadcast{topic: @topic, payload: payload, event: event} = info,
        socket
      ) do
    IO.inspect(info)

    socket =
      socket
      |> put_flash(:success, "Global message received: #{event}")

    {:noreply, socket}
  end
end

defmodule MyAppWeb.TodoLive do
  use MyAppWeb, :live_view

  alias MyAppWeb.Page
  alias MyAppWeb.Modal

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
end

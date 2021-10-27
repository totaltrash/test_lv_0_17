defmodule MyAppWeb.TodoLive do
  use MyAppWeb, :live_view

  alias MyAppWeb.Page
  alias MyAppWeb.Modal

  def render(assigns) do
    ~H"""
    <Page.wrapper current_menu="todo" title="To Do">
      <%= live_patch("Show Modal", to: Routes.todo_path(MyAppWeb.Endpoint, :show_modal), class: "flex items-center justify-center px-8 py-3 border border-transparent text-base font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 md:py-4 md:text-lg md:px-10") %>
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

  def handle_event("modal_confirm", _, socket) do
    IO.inspect("CONFIRMED :-)")

    {:noreply, push_patch(socket, to: Routes.todo_path(socket, :index))}
  end

  def handle_event("modal_cancel", _, socket) do
    IO.inspect("CANCELLED :-(")

    {:noreply, push_patch(socket, to: Routes.todo_path(socket, :index))}
  end
end

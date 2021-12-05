defmodule MyAppWeb.TemporaryAssignsLive do
  use MyAppWeb, :live_view

  alias MyAppWeb.Page

  def mount(_params, _session, socket) do
    socket = assign(socket, :messages, load_some_messages(socket))

    {:ok, socket, temporary_assigns: [messages: []]}
  end

  def render(assigns) do
    ~H"""
    <Page.wrapper current_menu="temporary_assigns" title="Temporary Assigns">
      <div class="flex flex-wrap items-center gap-4">
        <button phx-click="add_temporary_assign" class="flex items-center justify-center px-4 py-2 border border-transparent text-base font-medium rounded text-white md:py-3 md:text-lg md:px-6 bg-green-600 hover:bg-green-700">
          Add Temporary Assign
        </button>
      </div>
      <ul id="chat-messages" phx-update="prepend" class="mt-4">
        <%= for message <- @messages do %>
          <li id={"message_#{message.id}"}>
            <%= message.text %>
          </li>
        <% end %>
      </ul>
    </Page.wrapper>
    """
  end

  def handle_event("add_temporary_assign", _, socket) do
    {:noreply, assign(socket, :messages, [some_message()])}
  end

  defp load_some_messages(%{transport_pid: nil}), do: []

  defp load_some_messages(_) do
    1..Enum.random(3..11)
    |> Enum.map(fn _ -> some_message() end)
    |> Enum.reverse()
  end

  defp some_message() do
    id = System.unique_integer([:positive, :monotonic])
    %{id: id, text: "Hello #{id}"}
  end
end

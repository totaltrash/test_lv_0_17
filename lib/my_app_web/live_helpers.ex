defmodule MyAppWeb.LiveHelpers do
  def add_toast(socket, type, message) do
    MyApp.Accounts.Toast
    |> Ash.Changeset.for_create(:create, %{
      session_id: socket.assigns.session_id,
      message: message,
      type: type
    })
    |> MyApp.Accounts.create!()

    send(self(), {:reload_toasts})

    socket
  end
end

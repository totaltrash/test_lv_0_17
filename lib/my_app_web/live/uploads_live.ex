defmodule MyAppWeb.UploadsLive do
  use MyAppWeb, :live_view

  import IFixComponents.Page
  import IFixComponents.Button

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:uploaded_files, [])
     |> allow_upload(:avatar, accept: ~w(.pdf .docx), max_entries: 2)}
  end

  def render(assigns) do
    ~H"""
    <.wrapper current_menu="uploads" title="Uploads">
      <form id="upload-form" phx-submit="save" phx-change="validate">
        <%= live_file_input @uploads.avatar, class: "ZZsr-only" %>
        <.button type="submit" label="Upload" color="primary" />
      </form>

      <%# use phx-drop-target with the upload ref to enable file drag and drop %>
      <section phx-drop-target={@uploads.avatar.ref}>

        <%# render each avatar entry %>
        <%= for entry <- @uploads.avatar.entries do %>
          <article class="upload-entry">

            <figure>
              <%# Phoenix.LiveView.Helpers.live_img_preview/2 renders a client-side preview %>
              <%= live_img_preview entry %>
              <figcaption><%= entry.client_name %></figcaption>
            </figure>

            <%# entry.progress will update automatically for in-flight entries %>
            <progress value={entry.progress} max="100"> <%= entry.progress %>% </progress>

            <%# a regular click event whose handler will invoke Phoenix.LiveView.cancel_upload/3 %>
            <button phx-click="cancel-upload" phx-value-ref={entry.ref} aria-label="cancel">&times;</button>

            <%# Phoenix.LiveView.Helpers.upload_errors/2 returns a list of error atoms %>
            <%= for err <- upload_errors(@uploads.avatar, entry) do %>
              <p class="alert alert-danger"><%= error_to_string(err) %></p>
            <% end %>

          </article>
        <% end %>

        <%# Phoenix.LiveView.Helpers.upload_errors/1 returns a list of error atoms %>
        <%= for err <- upload_errors(@uploads.avatar) do %>
          <p class="alert alert-danger"><%= error_to_string(err) %></p>
        <% end %>

      </section>
    </.wrapper>
    """
  end

  def handle_event("save", _params, socket) do
    uploaded_files =
      consume_uploaded_entries(socket, :avatar, fn %{path: path}, _entry ->
        dest = Path.join([:code.priv_dir(:my_app), "static", "uploads", Path.basename(path)])
        # The `static/uploads` directory must exist for `File.cp!/2` to work.
        File.cp!(path, dest)
        {:ok, Routes.static_path(socket, "/uploads/#{Path.basename(dest)}")}
      end)

    {:noreply, update(socket, :uploaded_files, &(&1 ++ uploaded_files))}
  end

  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :avatar, ref)}
  end

  def error_to_string(:too_large), do: "Too large"
  def error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
  def error_to_string(:too_many_files), do: "You have selected too many files"
end

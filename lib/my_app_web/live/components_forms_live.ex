defmodule MyAppWeb.ComponentsFormsLive do
  use MyAppWeb, :live_view

  import IFixComponents.Page
  import IFixComponents.Form
  import IFixComponents.Button
  import IFixComponents.Table
  import MyAppWeb.ComponentsLive.Components

  def mount(_, _session, socket) do
    tags =
      MyApp.Blog.Tag
      |> MyApp.Blog.read!()
      |> Enum.map(fn tag -> {tag.title, tag.id} end)

    form =
      MyApp.Blog.Post
      |> AshPhoenix.Form.for_create(:create, api: MyApp.Blog)

    socket =
      socket
      # |> assign(options_int_value: [%{label: "One", id: 1}, %{label: "Two", id: 2}])
      |> assign(options_int_value: [One: 1, Two: 2])
      |> assign(tags: tags)
      |> assign(form: form)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.wrapper current_menu="components" title="Components">
      <.components_container>
        <.components_nav current="forms" />
      </.components_container>

      <.h1>Checkbox Array</.h1>
      <.h2>Int options</.h2>
      <.components_container>
        <.form let={f} for={:form} phx-submit="checkbox_array_submit" phx-change="checkbox_array_change">
          <.checkbox_array form={f} field={:roles} options={@options_int_value} />
          <.button type="submit" label="Submit" color="primary" />
        </.form>
      </.components_container>
      <.h2>Resource options</.h2>
      <div class="grid grid-cols-3 gap-4 mb-8">
        <.form
          let={f}
          for={@form}
          phx-submit="checkbox_array_submit"
          phx-change="checkbox_array_change"
          class="bg-white p-6 rounded"
        >
          <h2 class="text-gray-400 mb-2 font-bold tracking-wide uppercase">Add Post</h2>
          <%= label(f, :title) %>
          <%= text_input(f, :title, autocomplete: "off") %>
          <%= for error <- Keyword.get_values(f.errors, :title) do %>
            <span class="block text-red-700 text-sm">
              <%= translate_error(error) %>
            </span>
          <% end %>
          <%= label(f, :tags) %>
          <.checkbox_array form={f} field={:tags} options={@tags} />
          <div class="my-4">
            <.button type="submit" label="Submit" color="primary" />
          </div>
        </.form>
        <.live_component
          module={IFixComponents.ResourceLoader}
          id="posts_loader"
          api={MyApp.Blog}
          resource={MyApp.Blog.Post}
          let={items}
          class="col-span-2"
        >
          <.data_table items={items}>
            <:col label="Title" let={post}>
              <%= post.title %>
            </:col>
            <:col label="Tags" let={post}>
              <%= Enum.map(post.tags, fn %{title: title} -> title end) |> Enum.join(", ") %>
            </:col>
          </.data_table>
          <:pagination size={5} range={1} />
        </.live_component>
      </div>
      <.h1>Clearable Text Input</.h1>
      <.components_container>
        <.form let={f} for={:form} phx-submit="form_submit">
          <.clearable_text_input
            form={f}
            field={:test_clearable}
            value="Test"
          />
        </.form>
      </.components_container>
    </.wrapper>
    """
  end

  def handle_event("checkbox_array_change", %{"form" => params}, socket) do
    IO.inspect(params)

    # params = normalize_params(params, socket.assigns)
    form = socket.assigns.form
    validated_form = AshPhoenix.Form.validate(form, params, errors: form.submitted_once?)

    socket =
      socket
      |> assign(form: validated_form)

    {:noreply, socket}
  end

  def handle_event("checkbox_array_submit", %{"form" => params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form, params: params) do
      {:ok, _} ->
        {:noreply,
         socket
         |> add_toast(:info, "Post created")
         |> push_redirect(to: Routes.components_forms_path(socket, :index))}

      {:error, %AshPhoenix.Form{} = form} ->
        {:noreply, assign(socket, form: form)}
    end
  end
end

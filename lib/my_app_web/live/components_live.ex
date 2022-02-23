defmodule MyAppWeb.ComponentsLive do
  use MyAppWeb, :live_view

  @topic "messages"

  import MyAppWeb.Page
  import MyAppWeb.Modal
  import MyAppWeb.Button
  import MyAppWeb.Link
  import MyAppWeb.Form
  import MyAppWeb.Table
  import MyAppWeb.Icon
  import MyAppWeb.Dropdown
  import MyAppWeb.Paginator
  import MyAppWeb.Tabs

  def mount(_, _session, socket) do
    MyAppWeb.Endpoint.subscribe(@topic)

    socket =
      socket
      |> assign(data_table_items: [%{id: 1, name: "Some Name"}])
      |> assign(paginator_offset: 0)
      |> assign(paginator_limit: 10)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.wrapper current_menu="components" title="Components">
      <.h1>Tabs (Client Side)</.h1>
      <div class="flex gap-4 mb-8 flex-col md:flex-row">
        <.tabs id="tabs_test_1">
          <:tab label="Tab 1" icon="cog">
            <.h1>Hello</.h1>
            <p class="mb-2">
              Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut posuere nisi non enim mollis semper.
            </p>
            <p class="mb-2">
              Aenean convallis lorem a urna fringilla, a ornare mauris convallis. Cras sed arcu condimentum nisi dignissim sollicitudin. Vivamus ac suscipit nulla. Integer viverra sodales semper. Nullam dapibus eros nec lectus blandit blandit.
            </p>
            <p>
              Nam eget rutrum nunc. Proin nec porttitor augue, ut ultricies erat. Donec est enim, iaculis ultricies consectetur sed, sagittis in diam. Fusce sed lacus vel urna imperdiet finibus. Donec aliquam commodo rhoncus. Interdum et malesuada fames ac ante ipsum primis in faucibus. Sed hendrerit consectetur mollis. Aenean in nisi urna.
            </p>
          </:tab>
          <:tab label="Tab 2" icon="shield-check">
            <.h1>Ipsum Facto</.h1>
            <p class="mb-2">
              In hac habitasse platea dictumst. Fusce dui diam, dictum nec auctor eget, suscipit eu odio. Nullam bibendum dolor pellentesque est imperdiet pulvinar.
            </p>
            <p class="mb-2">
              Quisque lectus elit, sodales sed facilisis non, gravida ac ligula. Curabitur ultrices justo nec dapibus iaculis. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Etiam ac ante tortor. Praesent gravida dui nulla.
            </p>
            <p>
              Sed ac justo a leo commodo consequat nec nec risus. Suspendisse ultricies, massa eu sagittis dapibus, elit lectus vulputate diam, et fermentum lacus velit faucibus tellus. Phasellus fringilla hendrerit ligula, at mollis mauris vehicula quis. Nullam quam erat, dignissim eget ex eu, congue vulputate enim. Phasellus metus libero, egestas ac lacus tincidunt, hendrerit pulvinar augue.
            </p>
          </:tab>
          <:tab label="Tab 3" icon="cake">
            <.h1>Monkey See, Monkey Do</.h1>
            <p class="mb-2">
              In facilisis justo vitae tempus elementum. Fusce sodales dolor non nibh tempor, quis dignissim eros porttitor. Mauris pretium enim eros, eget pharetra augue vehicula eget. Suspendisse nec nibh commodo, ultrices ipsum nec, pretium nisl. Duis quam elit, imperdiet et auctor a, lobortis nec ligula.
            </p>
            <p class="mb-2">
              Lorem ipsum dolor sit amet, consectetur adipiscing elit.
            </p>
          </:tab>
        </.tabs>
        <.tabs id="tabs_test_2">
          <:tab label="Tab 1">
            <.h1>More Tabs</.h1>
            <p class="mb-2">
              Testing for leaks between the two tab components
            </p>
          </:tab>
          <:tab label="Tab 2">
            <.h1>Another Tab</.h1>
            <p class="mb-2">
              Another tab
            </p>
          </:tab>
        </.tabs>
      </div>

      <.h1>Paginator</.h1>
      <.components_container>
        <.paginator offset={@paginator_offset} limit={@paginator_limit} count={95} size={2} change_page="change_page" />
      </.components_container>

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
      <.h1>Modals</.h1>
      <.components_container>
        <.button type="link" color="primary" href={Routes.components_path(MyAppWeb.Endpoint, :show_alert_modal)} label="Alert Modal" />
        <.button type="link" color="primary" href={Routes.components_path(MyAppWeb.Endpoint, :show_confirm_modal)} label="Confirm Modal" />
        <.button type="link" color="primary" href={Routes.components_path(MyAppWeb.Endpoint, :show_form_modal)} label="Form Modal" />
        <.button type="link" color="primary" href={Routes.components_path(MyAppWeb.Endpoint, :show_custom_modal)} label="Custom Modal" />
      </.components_container>
      <.h1>Flashes</.h1>
      <.components_container>
        <.button click="add_flash" label="Add Flash" phx-value-type={:error} color="danger" />
        <.button click="add_flash" label="Add Flash" phx-value-type={:info} color="primary" />
        <.button click="add_flash" label="Add Flash" phx-value-type={:success} color={{:custom, "bg-green-600 hover:bg-green-700 text-white border-transparent focus:ring-green-700"}} />
      </.components_container>
      <.h1>Toasts</.h1>
      <.components_container>
        <.button click="add_toast" label="Add Toast" phx-value-type={:error} color="danger" />
        <.button click="add_toast" label="Add Toast" phx-value-type={:info} color="primary" />
        <.button click="add_toast" label="Add Toast" phx-value-type={:success} color={{:custom, "bg-green-600 hover:bg-green-700 text-white border-transparent focus:ring-green-700"}} />
        <.button click="add_toast_and_patch" label="Add Toast and Patch" phx-value-type={:success} color="primary" />
        <.button click="add_toast_and_redirect" label="Add Toast and redirect" phx-value-type={:success} color="primary" />
      </.components_container>
      <.h1>Messages</.h1>
      <.components_container>
        <.button click="send_local_message" label="Send Local Message" color="primary" />
        <.button click="send_global_message" label="Send Global Message" color="primary" />
      </.components_container>
      <.h1>Buttons</.h1>
      <.h2>Links</.h2>
      <.components_container>
        <.button
          type="link"
          href={Routes.components_path(MyAppWeb.Endpoint, :show_alert_modal)}
          label="Label"
          color="primary"
        />
        <.button
          type="link"
          href={Routes.components_path(MyAppWeb.Endpoint, :show_alert_modal)}
          color="primary"
        >Slot</.button>
        <.button
          type="link"
          href={Routes.components_path(MyAppWeb.Endpoint, :show_alert_modal)}
          label="Icon"
          color="primary"
          icon="home"
        />
        <.button
          type="link"
          href={Routes.components_path(MyAppWeb.Endpoint, :show_alert_modal)}
          label="Double Icon"
          color="primary"
          icon="home"
          right_icon="star"
        />
        <.button
          type="link"
          color={{:custom, "bg-green-600 hover:bg-green-700 text-white border-transparent focus:ring-green-700"}}
          href={Routes.components_path(MyAppWeb.Endpoint, :show_alert_modal)}
          label="Custom Color"
        />
        <.button
          type="link"
          link_type="redirect"
          href={Routes.components_path(MyAppWeb.Endpoint, :index)}
          label="Redirect"
          color="primary"
        />
        <.button
          type="link"
          link_type="external"
          href="https://www.thinkactively.com.au"
          label="External"
          target="_blank"
          color="primary"
        />
      </.components_container>
      <.h2>Buttons</.h2>
      <.components_container>
        <.button click="button_click" label="Label" color="primary" />
        <.button click="button_click" color="primary">Slot</.button>
        <.button click="button_click" label="Icon" icon="home" color="primary" />
        <.button click="button_click" label="Double Icon" icon="home" right_icon="star" color="primary" />
        <.button click="button_click" label="Custom Color" color={{:custom, "bg-green-600 hover:bg-green-700 text-white border-transparent focus:ring-green-700"}} />
      </.components_container>
      <.h2>Submit</.h2>
      <.form for={:form} phx-submit="form_submit">
        <.components_container>
          <.button type="submit" label="Label" color="primary" />
          <.button type="submit" color="primary">Slot</.button>
          <.button type="submit" label="Icon" icon="home" color="primary" />
          <.button type="submit" label="Double Icon" icon="home" right_icon="star" color="primary" />
          <.button type="submit" label="Custom Color" color={{:custom, "bg-green-600 hover:bg-green-700 text-white border-transparent focus:ring-green-700"}} />
        </.components_container>
      </.form>
      <.h2>Sizes</.h2>
      <.components_container>
        <.button click="button_click" label="Small (sm)" color="primary" size="sm" />
        <.button click="button_click" label="Normal (md)" color="primary" size="md" />
        <.button click="button_click" label="Large (lg)" color="primary" size="lg" />
      </.components_container>
      <.h1>Links</.h1>
      <.components_container>
        <.link
          href={Routes.components_path(MyAppWeb.Endpoint, :show_alert_modal)}
          label="Label"
        />
        <.link
          href={Routes.components_path(MyAppWeb.Endpoint, :show_alert_modal)}
        >Slot</.link>
        <.link
          href={Routes.components_path(MyAppWeb.Endpoint, :show_alert_modal)}
          label="Danger"
          color="danger"
        />
        <.link
          link_type="redirect"
          href={Routes.components_path(MyAppWeb.Endpoint, :index)}
          label="Redirect"
        />
        <.link
          href="https://www.thinkactively.com.au"
          link_type="external"
          label="External"
          target="_blank"
        />
        <.link
          color={{:custom, "text-green-600 hover:text-green-800 focus:text-green-800"}}
          href={Routes.components_path(MyAppWeb.Endpoint, :show_alert_modal)}
          label="Custom Color"
        />
        <.link
          class="focus:outline-indigo-700 text-indigo-500 hover:text-indigo-700 hover:underline focus:underline"
          href={Routes.components_path(MyAppWeb.Endpoint, :show_alert_modal)}
          label="Override Class"
        />
      </.components_container>
      <.h1>Dropdowns</.h1>
      <.components_container>
        <.dropdown
          label="Dropdown Left"
          color="primary"
          align="left"
          id="dropdown_1"
          icon="cog"
        >
          <.dropdown_heading label="Some Heading" />
          <.dropdown_link
            label="Link"
            href={Routes.components_path(MyAppWeb.Endpoint, :show_alert_modal)}
          />
          <.dropdown_link
            label="With icon"
            icon="home"
            href={Routes.components_path(MyAppWeb.Endpoint, :show_alert_modal)}
          />
          <.dropdown_divider />
          <.dropdown_link
            label="Redirect link"
            link_type="redirect"
            href={Routes.components_path(MyAppWeb.Endpoint, :show_alert_modal)}
          />
          <.dropdown_link
            label="Link to external, new tab"
            link_type="external"
            href="https://www.thinkactively.com.au"
            target="_blank"
          />
        </.dropdown>
        <.dropdown
          label="Drop Up"
          color="primary"
          direction="up"
          id="dropdown_2"
        >
          <.dropdown_link
            label="Link to external, new tab"
            link_type="external"
            href="https://www.thinkactively.com.au"
            target="_blank"
          />
        </.dropdown>
        <.dropdown
          label="Dropdown"
          color="primary"
          id="dropdown_3"
          icon="cog"
        >
          <.dropdown_heading label="Some Heading" />
          <.dropdown_link
            label="Link"
            href={Routes.components_path(MyAppWeb.Endpoint, :show_alert_modal)}
          />
          <.dropdown_link
            label="With icon"
            icon="home"
            href={Routes.components_path(MyAppWeb.Endpoint, :show_alert_modal)}
          />
          <.dropdown_divider />
          <.dropdown_link
            label="Redirect link"
            link_type="redirect"
            href={Routes.components_path(MyAppWeb.Endpoint, :show_alert_modal)}
          />
          <.dropdown_link
            label="Link to external, new tab"
            link_type="external"
            href="https://www.thinkactively.com.au"
            target="_blank"
          />
        </.dropdown>
      </.components_container>

      <.h1>Tables</.h1>
      <.h2>Simple Table</.h2>
      <.table class="mb-8">
        <.head>
          <.row>
            <.th class="w-1/4">Heading 1</.th>
            <.th>Heading 2</.th>
          </.row>
        </.head>
        <.body>
          <.row>
            <.td>Row 1</.td>
            <.td>Something here</.td>
          </.row>
          <.row class="bg-red-700 text-white">
            <.td>Row 2</.td>
            <.td>Something here</.td>
          </.row>
        </.body>
      </.table>
      <.h2>Data Table</.h2>
      <.data_table items={@data_table_items} class="mb-8">
        <:col let={item} label="ID" th_class="w-1/4">
          <%= item.id %>
        </:col>
        <:col let={item} label="Name">
          <%= item.name %>
        </:col>
      </.data_table>
      <.h2>Empty Data Table</.h2>
      <.data_table items={[]} class="mb-8">
        <:col let={item} label="ID" th_class="w-1/4">
          <%= item.id %>
        </:col>
        <:col let={item} label="Name">
          <%= item.name %>
        </:col>
      </.data_table>
      <.h1>Boolean Icon</.h1>
      <.components_container>
        <.boolean_icon value={true} />
        <.boolean_icon value={false} />
        <.boolean_icon value={true} type="solid" />
        <.boolean_icon value={false} type="solid" />
        <.boolean_icon value={true} class="h-12 w-12" type="solid" />
        <.boolean_icon value={false} class="h-12 w-12" type="solid" />
      </.components_container>
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
              <.modal_button label="Do It" color="danger" click="custom_modal_do_it" />
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

  def handle_event("change_page", %{"page" => page}, socket) do
    socket =
      socket
      |> assign(paginator_offset: (String.to_integer(page) - 1) * socket.assigns.paginator_limit)

    {:noreply, socket}
  end

  def handle_event("custom_modal_do_it", _, socket) do
    socket =
      socket
      |> add_toast(:success, "Custom modal doing it")
      |> push_patch(to: Routes.components_path(socket, :index))

    {:noreply, socket}
  end

  def handle_event("custom_modal_close", _, socket) do
    socket =
      socket
      |> add_toast(:info, "Custom modal closed")
      |> push_patch(to: Routes.components_path(socket, :index))

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
      |> push_patch(to: Routes.components_path(socket, :index))

    {:noreply, socket}
  end

  def handle_event("add_toast_and_redirect", %{"type" => _type}, socket) do
    socket =
      socket
      |> add_toast(:error, "Hello toast and redirect")
      |> push_redirect(to: Routes.components_path(socket, :index))

    {:noreply, socket}
  end

  def handle_event("alert_modal_ok", _, socket) do
    socket =
      socket
      |> push_patch(to: Routes.components_path(socket, :index))

    {:noreply, socket}
  end

  def handle_event("confirm_modal_ok", _, socket) do
    socket =
      socket
      |> add_toast(:success, "Wow, you confirmed, stand by...")
      |> push_patch(to: Routes.components_path(socket, :index))

    {:noreply, socket}
  end

  def handle_event("confirm_modal_cancel", _, socket) do
    socket =
      socket
      |> add_toast(:info, "Cancelled, that's a good call")
      |> push_patch(to: Routes.components_path(socket, :index))

    {:noreply, socket}
  end

  def handle_event("form_modal_cancel", _, socket) do
    socket =
      socket
      |> add_toast(:info, "Cancelled form modal")
      |> push_patch(to: Routes.components_path(socket, :index))

    {:noreply, socket}
  end

  def handle_event("form_modal_submit", _params, socket) do
    socket =
      socket
      |> add_toast(:info, "Submitted form modal")
      |> push_patch(to: Routes.components_path(socket, :index))

    {:noreply, socket}
  end

  def handle_event("form_submit", _params, socket) do
    socket =
      socket
      |> add_toast(:info, "Submitted form")
      |> push_patch(to: Routes.components_path(socket, :index))

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
      |> push_patch(to: Routes.components_path(socket, :index))

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

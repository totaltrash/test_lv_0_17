defmodule MyAppWeb.Modal do
  use Phoenix.Component
  import Heroicons.LiveView
  alias Phoenix.LiveView.JS
  alias MyAppWeb.Button

  @doc """
  Creates an opinionated alert modal. Icons, colours, and buttons are set
  (use `modal/1` instead to override).

  Handling of events to be implemented in the LiveView/parent live component

      assigns:
        :heading  required: true
        :ok       required: true
  """
  def alert_modal(assigns) do
    ~H"""
    <.modal heading={@heading} icon="bell">
      <%= render_slot(@inner_block) %>
      <:buttons>
        <.modal_button label="OK" variant="primary" click={@ok} />
      </:buttons>
    </.modal>
    """
  end

  @doc """
  Creates an opinionated confirm modal. Icons, colours, and buttons are set
  (use `modal/1` instead to override).

  Handling of events to be implemented in the LiveView/parent live component

      assigns:
        :heading  required: true
        :ok       required: true
        :cancel   required: true
  """
  def confirm_modal(assigns) do
    ~H"""
    <.modal heading={@heading} icon="question-mark-circle">
      <%= render_slot(@inner_block) %>
      <:buttons>
        <.modal_button label="OK" variant="primary" click={@ok} />
        <.modal_button label="Cancel" variant="modal_default" click={@cancel} />
      </:buttons>
    </.modal>
    """
  end

  @doc """
  Creates an opinionated form modal. Icons, colours, and buttons are set
  (use `modal/1` instead to override).

  Handling of events to be implemented in the LiveView/parent live component

      assigns:
        :heading      required: true
        :form         required: true
        :form_submit  required: true
        :cancel       required: true
  """
  def form_modal(assigns) do
    ~H"""
    <.modal heading={@heading} let={f} form={@form} form_submit={@form_submit} icon="pencil">
      <%= render_slot(@inner_block, f) %>
      <:buttons>
        <.modal_button label="Submit" variant="primary" type="submit" />
        <.modal_button label="Cancel" variant="modal_default" click={@cancel} />
      </:buttons>
    </.modal>
    """
  end

  @doc """
  Creates a modal.

  Handling of events to be implemented in the LiveView/parent live component

      assigns:
        :heading      required: true
        :close        required: false, default: false (not closable by click away or escape when false)
        :icon         required: false, default: "information-circle"
        :icon_type    required: false, default: "outline"
        :icon_colour  required: false, default: "bg-sky-100 text-sky-600"
        :form         required: false, default: nil
        :form_submit  required: false, default: nil (required when form is provided)

      slots:
        :buttons
  """
  def modal(assigns) do
    assigns =
      assigns
      |> assign_new(:close, fn -> false end)
      |> assign_new(:icon, fn -> "information-circle" end)
      |> assign_new(:icon_type, fn -> "outline" end)
      |> assign_new(:icon_color, fn -> "bg-sky-100 text-sky-600" end)
      |> assign_new(:form, fn -> nil end)
      |> assign_new(:form_submit, fn -> nil end)

    ~H"""
    <div
      id="modal-container"
      phx-remove={hide_modal()}
      class="fixed z-10 inset-0 overflow-y-auto"
      aria-labelledby="modal-title"
      role="dialog"
      aria-modal="true"
    >
      <div class="flex items-end justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
        <div id="modal-overlay" class="fade-in fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" aria-hidden="true"></div>
        <span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">&#8203;</span>
        <div
          id="modal"
          phx-click-away={@close}
          phx-window-keydown={@close}
          phx-key="escape"
          class="fade-in-scale inline-block align-bottom bg-white rounded-lg text-left overflow-hidden shadow-xl transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full"
        >
          <.form_wrapper let={f} form={@form} form_submit={@form_submit}>
            <div class="bg-white px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
              <div class="sm:flex sm:items-start">
                <div class={"#{@icon_color} mx-auto flex-shrink-0 flex items-center justify-center h-12 w-12 rounded-full sm:mx-0 sm:h-10 sm:w-10"}>
                  <.icon name={@icon} type={@icon_type} class="h-6 w-6" />
                </div>
                <div class="grow mt-3 text-center sm:mt-2 sm:ml-4 sm:text-left">
                  <h3 class="text-lg leading-6 font-medium text-gray-900" id="modal-title">
                    <%= @heading %>
                  </h3>
                  <div class="mt-2">
                    <p class="text-sm text-gray-500">
                      <%= render_slot(@inner_block, f) %>
                    </p>
                  </div>
                </div>
              </div>
            </div>
            <div class="bg-gray-50 px-4 py-3 sm:px-6 flex flex-col sm:flex-row-reverse gap-3">
              <%= render_slot(@buttons) %>
            </div>
          </.form_wrapper>
        </div>
      </div>
    </div>
    """
  end

  @doc """
  Creates a modal button.

  Handling of events to be implemented in the LiveView/parent live component, including if only needs to be a link

      assigns:
        :label    required: true
        :type     required: false, default: "button", options: ["button", "submit"]
        :click    required: false, default: false (should be provided if type == "button", not if type == "submit")
        :variant  required: false, default: "modal_default"

  """
  def modal_button(assigns) do
    assigns =
      assigns
      |> assign_new(:type, fn -> "button" end)
      |> assign_new(:click, fn -> false end)
      |> assign_new(:variant, fn -> "modal_default" end)

    ~H"""
    <button
      type={@type}
      phx-click={@click}
      class={"#{button_base_class()} #{Button.variant(@variant)}"}
    >
      <%= @label %>
    </button>
    """
  end

  defp hide_modal(js \\ %JS{}) do
    js
    |> JS.hide(to: "#modal-overlay", transition: "fade-out")
    |> JS.hide(to: "#modal", transition: "fade-out-scale")
  end

  defp button_base_class(),
    do:
      "w-full inline-flex justify-center rounded-md border shadow-sm px-4 py-2 text-base font-medium focus:outline-none focus:ring-2 focus:ring-offset-2 sm:w-auto sm:text-sm"

  defp form_wrapper(%{form: nil} = assigns) do
    ~H"""
    <%= render_slot(@inner_block, nil) %>
    """
  end

  defp form_wrapper(assigns) do
    ~H"""
    <.form let={f} for={@form} phx-submit={@form_submit}>
      <%= render_slot(@inner_block, f) %>
    </.form>
    """
  end
end

defmodule MyAppWeb.Modal do
  use Phoenix.Component
  import Heroicons.LiveView
  alias Phoenix.LiveView.JS

  defp hide_modal(js \\ %JS{}) do
    js
    |> JS.hide(
      to: "#confirm-modal-overlay",
      transition: "fade-out"
      # the following does not work when setting 'fade-in' on #confirm-modal-overlay
      # transition: {
      #   "ease-in duration-200",
      #   "opacity-100",
      #   "opacity-0"
      # }
    )
    |> JS.hide(
      to: "#confirm-modal",
      transition: "fade-out-scale"
      # the following does not work when setting 'fade-in-scale' on #confirm-modal
      # transition: {
      #   "ease-in duration-200",
      #   "opacity-100 translate-y-0 sm:scale-100",
      #   "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
      # }
    )
  end

  def confirm_modal(assigns) do
    ~H"""
    <div
      id="confirm-modal-container"
      phx-remove={hide_modal()}
      class="fixed z-10 inset-0 overflow-y-auto"
      aria-labelledby="modal-title"
      role="dialog"
      aria-modal="true"
    >
      <div class="flex items-end justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
        <!--
          Background overlay, show/hide based on modal state.

          Entering: "ease-out duration-300"
            From: "opacity-0"
            To: "opacity-100"
          Leaving: "ease-in duration-200"
            From: "opacity-100"
            To: "opacity-0"
        -->
        <div id="confirm-modal-overlay" class="fade-in fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" aria-hidden="true"></div>

        <!-- This element is to trick the browser into centering the modal contents. -->
        <span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">&#8203;</span>

        <!--
          Modal panel, show/hide based on modal state.

          Entering: "ease-out duration-300"
            From: "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
            To: "opacity-100 translate-y-0 sm:scale-100"
          Leaving: "ease-in duration-200"
            From: "opacity-100 translate-y-0 sm:scale-100"
            To: "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
        -->
        <div
          id="confirm-modal"
          phx-click-away={JS.dispatch("click", to: "#confirm-modal-cancel")}
          phx-window-keydown={JS.dispatch("click", to: "#confirm-modal-cancel")}
          phx-key="escape"
          class="fade-in-scale inline-block align-bottom bg-white rounded-lg text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full"
        >
          <div class="bg-white px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
            <div class="sm:flex sm:items-start">
              <div class="mx-auto flex-shrink-0 flex items-center justify-center h-12 w-12 rounded-full bg-red-100 sm:mx-0 sm:h-10 sm:w-10">
                <.icon name="exclamation" type="outline" class="h-6 w-6 text-red-600" />
              </div>
              <div class="mt-3 text-center sm:mt-0 sm:ml-4 sm:text-left">
                <h3 class="text-lg leading-6 font-medium text-gray-900" id="modal-title">
                  <%= @heading %>
                </h3>
                <div class="mt-2">
                  <p class="text-sm text-gray-500">
                  <%= render_slot(@inner_block) %>
                  </p>
                </div>
              </div>
            </div>
          </div>
          <div class="bg-gray-50 px-4 py-3 sm:px-6 sm:flex sm:flex-row-reverse">
            <button phx-click={ @confirm } type="button" class="w-full inline-flex justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-red-600 text-base font-medium text-white hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500 sm:ml-3 sm:w-auto sm:text-sm">
              Confirm
            </button>
            <button id="confirm-modal-cancel" phx-click={ @cancel } type="button" class="mt-3 w-full inline-flex justify-center rounded-md border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:mt-0 sm:ml-3 sm:w-auto sm:text-sm">
              Cancel
            </button>
          </div>
        </div>
      </div>
    </div>
    """
  end
end

defmodule IFixComponents.Tabs do
  use Phoenix.Component

  import Heroicons.LiveView

  alias Phoenix.LiveView.JS

  @active_tab_classes "active_tab bg-sky-200 text-sky-800"

  # assigns:
  #     :id           required: true, (DOM id for component, needs to be unique as used by JS when switching tab and content states)
  #     :active_index required: false, default: 0, which tab to display when mounted
  #
  # slots:
  #   :tab
  #     :label        required: true, label to display in the tab
  #     :icon         required: false, optional icon to display in the tab
  #     :inner_block  required: true, contents to display when tab selected
  def tabs(assigns) do
    assigns =
      assigns
      |> assign_new(:tab, fn -> [] end)
      |> assign_new(:active_index, fn -> 0 end)

    ~H"""
    <div id={@id} class="w-full bg-white rounded p-6">
      <div class="flex flex-row gap-4 items-center">
        <%= for {tab, index} <- Enum.with_index(@tab) do %>
          <a
            id={"#{@id}_#{index}"}
            class={"flex flex-row flex-nowrap items-center gap-2 px-4 py-2 rounded bg-gray-100 text-gray-600 font-medium #{get_active_tab(@active_index, index)}"}
            phx-click={click_tab(@id, index)}
            href="#"
          >
            <%= if tab[:icon] do %>
              <.icon name={tab.icon} type="solid" class="h-4 w-4" />
            <% end %>
              <span class="whitespace-nowrap"><%= tab.label %></span>
          </a>
        <% end %>
      </div>
      <div>
        <%= for {tab, index} <- Enum.with_index(@tab) do %>
          <div
            id={"#{@id}_#{index}_content"}
            class={"tab_content z-0 pt-6 #{get_active_content(@active_index, index)}"}
          >
            <%= render_slot(tab) %>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  defp get_active_tab(active_index, active_index) do
    @active_tab_classes
  end

  defp get_active_tab(_active_index, _index) do
    ""
  end

  defp get_active_content(active_index, active_index) do
    ""
  end

  defp get_active_content(_active_index, _index) do
    "hidden"
  end

  defp click_tab(js \\ %JS{}, id, index) do
    js
    |> JS.add_class("hidden",
      to: "div##{id} .tab_content",
      transition: "fade-out"
    )
    |> JS.remove_class("hidden",
      to: "div##{id}_#{index}_content",
      transition: "fade-in"
    )
    |> JS.remove_class(@active_tab_classes, to: "div##{id} .active_tab")
    |> JS.add_class(@active_tab_classes, to: "a##{id}_#{index}")
  end
end

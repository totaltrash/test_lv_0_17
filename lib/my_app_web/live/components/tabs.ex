defmodule MyAppWeb.Tabs do
  use Phoenix.Component
  # import Heroicons.LiveView
  alias Phoenix.LiveView.JS

  @active_tab_classes "active_tab bg-sky-200 text-sky-800"

  def tabs(assigns) do
    assigns =
      assigns
      |> assign_new(:tab, fn -> [] end)
      |> assign_new(:active_index, fn -> 0 end)

    ~H"""
    <div class="w-full bg-white rounded p-6">
      <div id={@id} class="flex flex-row gap-4 items-center">
        <%= for {tab, index} <- Enum.with_index(@tab) do %>
          <a
            id={"#{@id}_#{index}"}
            class={"px-4 py-2 rounded bg-gray-100 text-gray-600 font-medium #{get_active_tab(@active_index, index)}"}
            phx-click={click_tab(@id, index)}
            href="#"
          >
            <%= tab.label %>
          </a>
        <% end %>
      </div>
      <div class="zrelative">
        <%= for {tab, index} <- Enum.with_index(@tab) do %>
          <div
            id={"#{@id}_#{index}_content"}
            class={"tab_content zabsolute z-0 pt-6 #{get_active_content(@active_index, index)}"}
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
    |> JS.add_class("hidden", to: "div.tab_content")
    |> JS.remove_class("hidden", to: "##{id}_#{index}_content")
    |> JS.remove_class(@active_tab_classes, to: ".active_tab")
    |> JS.add_class(@active_tab_classes, to: "##{id}_#{index}")
  end
end

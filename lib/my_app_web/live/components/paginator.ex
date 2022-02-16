defmodule MyAppWeb.Paginator do
  use Phoenix.Component

  import Heroicons.LiveView

  def paginator(assigns) do
    %{offset: offset, limit: limit, count: count, size: size} = assigns
    page_count = page_count(count, limit)
    page = div(offset + limit, limit)

    assigns =
      assigns
      |> assign(page: page)
      |> assign(page_count: page_count)
      |> assign(previous_pages: Enum.filter((page - size)..(page - 1), &(&1 > 0)))
      |> assign(show_previous_range: page - 1 > size)
      |> assign(next_pages: Enum.filter((page + 1)..(page + size), &(&1 <= page_count)))
      |> assign(show_next_range: page + size < page_count)
      |> assign(record_range_start: min(offset + 1, count))
      |> assign(record_range_end: min(offset + limit, count))

    ~H"""
      <div class="bg-white py-3 flex items-center justify-between border-t border-gray-200 px-0 md:px-6" data-role="paginator">
        <div class="md:flex-1 md:flex md:items-center md:justify-between md:gap-4">
          <div class="hidden md:block">
            <p class="text-sm text-gray-700">
              Showing <span class="font-medium"><%= @record_range_start %></span> to <span class="font-medium"><%= @record_range_end %></span> of <span class="font-medium"><%= @count %></span> results
            </p>
          </div>
          <div>
            <nav class="inline-flex shadow-sm -space-x-px h-9" aria-label="Pagination">
              <.paginator_item click={@change_page} icon="chevron-double-left" page={1} enabled={@page != 1} />
              <.paginator_item click={@change_page} icon="chevron-left" page={max(@page - 1, 1)} enabled={@page != 1} />
              <%= if @show_previous_range do %>
                <.paginator_item icon="dots-horizontal" enabled={false} hide_on_mobile />
              <% end %>
              <%= for page <- @previous_pages do %>
                <.paginator_item click={@change_page} page={page} hide_on_mobile />
              <% end %>
              <.paginator_item selected page={@page} />
              <%= for page <- @next_pages do %>
                <.paginator_item click={@change_page} page={page} hide_on_mobile />
              <% end %>
              <%= if @show_next_range do %>
                <.paginator_item icon="dots-horizontal" enabled={false} hide_on_mobile />
              <% end %>
              <.paginator_item click={@change_page} icon="chevron-right" page={min(@page + 1, @page_count)} enabled={@page != @page_count} />
              <.paginator_item click={@change_page} icon="chevron-double-right" page={@page_count} enabled={@page != @page_count} />
            </nav>
          </div>
        </div>
      </div>
    """
  end

  defp page_count(0, _limit), do: 1

  defp page_count(count, limit) do
    if rem(count, limit) > 0 do
      div(count, limit) + 1
    else
      div(count, limit)
    end
  end

  defp paginator_item(assigns) do
    assigns =
      assigns
      |> assign_new(:page, fn -> nil end)
      |> assign_new(:icon, fn -> nil end)
      |> assign_new(:enabled, fn -> true end)
      |> assign_new(:selected, fn -> false end)
      |> assign_new(:hide_on_mobile, fn -> false end)
      |> assign_new(:click, fn -> nil end)

    ~H"""
    <%= if @enabled and not @selected do %>
      <a phx-click={@click} phx-value-page={@page} phx-page-loading href="#" class={paginator_item_class(@enabled, @selected, @hide_on_mobile)}>
        <.paginator_item_label icon={@icon} page={@page} />
      </a>
    <% else %>
      <span class={paginator_item_class(@enabled, @selected, @hide_on_mobile)} data-role={paginator_item_role(@selected)}>
        <.paginator_item_label icon={@icon} page={@page} />
      </span>
    <% end %>
    """
  end

  defp paginator_item_label(assigns) do
    ~H"""
    <%= if @icon != nil do %>
      <.icon name={@icon} type="solid" class="h-4 w-4" />
    <% else %>
      <%= @page %>
    <% end %>
    """
  end

  defp paginator_item_class(enabled, selected, hide_on_mobile) do
    [
      {"items-center justify-center w-9 text-sm font-medium border", true},
      {"hidden sm:inline-flex", hide_on_mobile},
      {"inline-flex", not hide_on_mobile},
      {"border-sky-700 text-white bg-sky-700", selected},
      {"border-gray-300 bg-white", not selected},
      {"text-gray-700 hover:bg-gray-100", not selected and enabled},
      {"text-gray-400", not selected and not enabled}
    ]
    |> Enum.filter(fn {_, show} -> show end)
    |> Enum.map(fn {classes, _} -> classes end)
    |> Enum.join(" ")
  end

  defp paginator_item_role(true), do: "selected-page"
  defp paginator_item_role(_), do: nil
end

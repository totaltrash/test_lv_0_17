defmodule MyAppWeb.Table do
  use Phoenix.Component

  # assigns:
  #     :items          required: true
  #     :class          required: false, default: nil (extra classes to add to the default)
  #     :empty_message  required: false, default: "None found"
  #
  # named slots:
  #     :col            attributes:
  #                       :label    required: true
  #                       :th_class required: false, default: ""
  def data_table(assigns) do
    assigns =
      assigns
      |> assign_new(:class, fn -> nil end)
      |> assign_new(:empty_message, fn -> "None found" end)

    ~H"""
    <.table class={@class}>
      <.head>
        <.row>
          <%= for col <- @col do %>
            <.th class={th_class(col)}><%= col.label %></.th>
          <% end %>
        </.row>
      </.head>
      <.body>
        <%= if Enum.count(@items) == 0 do %>
          <.row>
            <.td colspan={Enum.count(@col)} class="italic">
              <%= @empty_message%>
            </.td>
          </.row>
        <% else %>
          <%= for item <- @items do %>
            <.row>
              <%= for col <- @col do %>
                <.td><%= render_slot(col, item) %></.td>
              <% end %>
            </.row>
          <% end %>
        <% end %>
      </.body>
    </.table>
    """
  end

  defp th_class(%{th_class: th_class}), do: th_class
  defp th_class(_), do: ""

  # assigns:
  #     :class        required: false, default: nil (extra classes to add to the default)
  def table(assigns) do
    extra = assigns_to_attributes(assigns, [:class])

    assigns =
      assigns
      |> assign(:extra, extra)
      |> assign_new(:class, fn -> nil end)

    ~H"""
    <div class={@class}>
      <div class="-my-2 overflow-x-auto sm:-mx-6 lg:-mx-8">
        <div class="py-2 align-middle inline-block min-w-full sm:px-6 lg:px-8">
          <div class="overflow-hidden border-b border-gray-100">
            <table class="min-w-full">
              <%= render_slot(@inner_block) %>
            </table>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def head(assigns) do
    ~H"""
    <thead class="bg-gray-50">
      <%= render_slot(@inner_block) %>
    </thead>
    """
  end

  def body(assigns) do
    ~H"""
    <tbody class="bg-white divide-y divide-gray-100">
      <%= render_slot(@inner_block) %>
    </tbody>
    """
  end

  # assigns:
  #     :class        required: false, default: nil (extra classes to add to the default)
  def row(assigns) do
    assigns =
      assigns
      |> assign_new(:class, fn -> nil end)

    ~H"""
    <tr class={@class}>
      <%= render_slot(@inner_block) %>
    </tr>
    """
  end

  # assigns:
  #     :content      required: false, default: nil (extra classes to add to the default)
  #     :class        required: false, default: nil (extra classes to add to the default)
  #     :colspan      required: false, default: nil (extra classes to add to the default)
  def td(assigns) do
    assigns =
      assigns
      |> assign_new(:content, fn -> nil end)
      |> assign_new(:class, fn -> nil end)
      |> assign_new(:colspan, fn -> nil end)

    ~H"""
    <td class={"px-4 sm:px-6 py-4 whitespace-nowrap align-top #{@class}"} colspan={@colspan}>
      <%= @content || render_slot(@inner_block) %>
    </td>
    """
  end

  # assigns:
  #     :content      required: false, default: nil (extra classes to add to the default)
  #     :class        required: false, default: nil (extra classes to add to the default)
  #     :colspan      required: false, default: nil (extra classes to add to the default)
  def th(assigns) do
    assigns =
      assigns
      |> assign_new(:content, fn -> nil end)
      |> assign_new(:class, fn -> nil end)
      |> assign_new(:colspan, fn -> nil end)

    ~H"""
    <th class={"px-4 sm:px-6 py-3 text-left text-sm font-medium text-gray-600 #{@class}"} colspan={@colspan}>
      <%= @content || render_slot(@inner_block) %>
    </th>
    """
  end
end

defmodule MyAppWeb.TodoLive do
  use MyAppWeb, :live_view

  alias MyAppWeb.Page

  def render(assigns) do
    ~H"""
    <Page.wrapper current_menu="todo" title="To Do">
      To do stuff here
    </Page.wrapper>
    """
  end
end

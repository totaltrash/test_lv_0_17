defmodule MyAppWeb.HomeLive do
  use MyAppWeb, :live_view

  alias MyAppWeb.Page

  def render(assigns) do
    ~H"""
    <Page.wrapper current_menu="home" title="Home">
      Home stuff here
    </Page.wrapper>
    """
  end
end

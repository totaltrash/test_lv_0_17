defmodule MyAppWeb.HomeLive do
  use MyAppWeb, :live_view

  import IFixComponents.Page

  def render(assigns) do
    ~H"""
    <.wrapper current_menu="home" title="Home">
      Home stuff here
    </.wrapper>
    """
  end
end

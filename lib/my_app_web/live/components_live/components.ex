defmodule MyAppWeb.ComponentsLive.Components do
  use Phoenix.Component

  import IFixComponents.Nav

  alias MyAppWeb.Router.Helpers, as: Routes

  def components_nav(assigns) do
    ~H"""
    <div class="bg-white p-6 rounded w-full">
      <.nav current={@current}>
        <:nav_item id="components" label="Components" icon="puzzle" href={Routes.components_path(MyAppWeb.Endpoint, :index)} />
        <:nav_item id="tables" label="Tables" icon="table" href={Routes.components_tables_path(MyAppWeb.Endpoint, :index)} />
        <:nav_item id="forms" label="Forms" icon="pencil-alt" href={Routes.components_forms_path(MyAppWeb.Endpoint, :index)} />
      </.nav>
    </div>
    """
  end
end

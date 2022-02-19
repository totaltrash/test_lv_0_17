defmodule MyApp.Calendar.Event.Preparations.Filter do
  use Ash.Resource.Preparation

  require Ash.Query

  def prepare(query, _opts, _) do
    {keyword, _active} =
      query
      |> Ash.Query.get_argument(:filter)
      |> normalize_filter()

    query
    |> apply_keyword_filter(keyword)

    # |> apply_active_filter(active)
  end

  # Just in case the format of the filter changes and an old version is pulled from a session
  defp normalize_filter(%{keyword: keyword, active: active}) do
    {keyword, active}
  end

  defp normalize_filter(%{"keyword" => keyword, "active" => active}) do
    {keyword, String.to_existing_atom(active)}
  end

  defp normalize_filter(_), do: {"", true}

  defp apply_keyword_filter(query, ""), do: query

  defp apply_keyword_filter(query, keyword) do
    keyword = %Ash.CiString{string: keyword}

    Ash.Query.filter(
      query,
      contains(title, ^keyword)
    )
  end

  # defp apply_active_filter(query, active) do
  #   Ash.Query.filter(query, active == ^active)
  # end
end

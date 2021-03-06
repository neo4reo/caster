defmodule Caster.CastView do
  use Caster.Web, :view

  def cast_link(conn, cast = %{file_location: nil}) do
    button "Download", to: cast_download_path(conn, :create, cast), class: "btn btn-default btn-xs"
  end

  def cast_link(conn, cast) do
    link "Show", to: cast_path(conn, :show, cast), class: "btn btn-default btn-xs"
  end

  def render("index.json", assigns) do
    %{
      title: assigns.source.title,
      removeable: assigns.source |> Map.get(:removeable, true),
      refreshable: assigns.source |> Map.get(:refreshable, false),
      casts: render_many(assigns.casts, __MODULE__, "cast.json")
    }
  end

  def render("cast.json", %{cast: cast}) do
    %{
      id: cast.id,
      interesting: cast.interesting,
      title: cast.title,
      source: cast.source,
      note: cast.note,
      state: state(cast)
    }
  end

  defp state(%{viewed: true}), do: "viewed"
  defp state(%{file_location: file_location}) when is_binary(file_location), do: "downloaded"
  defp state(_), do: "fresh"
end

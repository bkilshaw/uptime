defmodule Uptime.SitesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Uptime.Sites` context.
  """

  @doc """
  Generate a site.
  """
  def site_fixture(attrs \\ %{}) do
    {:ok, site} =
      attrs
      |> Enum.into(%{
        url: "some url"
      })
      |> Uptime.Sites.create_site()

    site
  end
end

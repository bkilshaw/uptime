defmodule UptimeWeb.SiteLive.Index do
  use UptimeWeb, :live_view

  alias Uptime.Sites
  alias Uptime.Sites.Site

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :sites, Sites.list_sites(socket.assigns.current_user.id))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Site")
    |> assign(:site, Sites.get_site!(socket.assigns.current_user.id, id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Site")
    |> assign(:site, %Site{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Sites")
    |> assign(:site, nil)
  end

  @impl true
  def handle_info({UptimeWeb.SiteLive.FormComponent, {:saved, site}}, socket) do
    {:noreply, stream_insert(socket, :sites, site)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    site = Sites.get_site!(socket.assigns.current_user.id, id)
    {:ok, _} = Sites.delete_site(site)

    {:noreply, stream_delete(socket, :sites, site)}
  end
end

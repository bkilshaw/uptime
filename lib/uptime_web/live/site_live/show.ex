defmodule UptimeWeb.SiteLive.Show do
  use UptimeWeb, :live_view

  alias Uptime.Sites

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:site, Sites.get_site!(socket.assigns.current_user.id, id))}
  end

  defp page_title(:show), do: "Show Site"
  defp page_title(:edit), do: "Edit Site"
end

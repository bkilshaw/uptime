defmodule Uptime.Checker do
  use GenStage

  def start_link() do
    GenStage.start_link(__MODULE__, nil)
  end

  def init(_) do
    {:consumer, []}
  end

  def handle_events(events, _from, state) do
    Enum.each(events, fn event ->
      {checked_at, status} = result = check(event.site)
      my_pid = self()
      IO.puts("#{inspect(my_pid)} #{checked_at} #{status} #{event.site.url}")
      Uptime.SiteMonitor.update_status(event.site_monitor_pid, result)
    end)

    {:noreply, [], state}
  end

  def check(%Uptime.Sites.Site{} = site) do
    case Req.get(site.url) do
      {:ok, _response} -> {DateTime.utc_now(), :ok}
      {:error, error} -> {DateTime.utc_now(), error.reason}
    end
  end
end

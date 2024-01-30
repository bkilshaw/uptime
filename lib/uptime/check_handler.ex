defmodule Uptime.CheckHandler do
  use GenStage
  alias Uptime.Sites.Site

  def start_link() do
    GenStage.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def check(%Site{} = site, site_monitor_pid) when is_pid(site_monitor_pid) do
    GenStage.cast(__MODULE__, {:check, site, site_monitor_pid})
  end

  def status() do
    status = GenStage.call(__MODULE__, :status)
    IO.inspect(status, label: "The CheckHandler Status is")
  end

  @impl true
  def init(_) do
    {:producer, []}
  end

  @impl true
  def handle_cast({:check, site, site_monitor_pid}, state) do
    event = [%{site: site, site_monitor_pid: site_monitor_pid}]
    {:noreply, event, state}
  end

  @impl true
  def handle_demand(demand, checks) when demand > 0 do
    {give, remaining} = Enum.split(checks, demand)
    {:noreply, give, remaining}
  end

  @impl true
  def handle_call(:status, _from, state) do
    {:reply, state, [:status], state}
  end
end

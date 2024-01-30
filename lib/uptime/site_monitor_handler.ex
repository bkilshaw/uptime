defmodule Uptime.SiteMonitorHandler do
  use GenServer

  alias Uptime.SiteMonitor
  alias Uptime.Sites.Site

  def start() do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def monitor(%Site{} = site) do
    GenServer.cast(__MODULE__, {:monitor, site})
  end

  def status() do
    GenServer.call(__MODULE__, :status)
  end

  def get_site_pid(site_id) when is_binary(site_id) do
    GenServer.call(__MODULE__, {:get_site_pid, site_id})
  end

  @impl true
  def init(_) do
    {:ok, %{}}
  end

  @impl true
  def handle_cast({:monitor, %Site{} = site}, state) do
    {:ok, pid} = SiteMonitor.start(site)
    state = Map.put(state, site.id, pid)
    {:noreply, state}
  end

  @impl true
  def handle_call(:status, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call({:get_site_pid, site_id}, _from, status) do
    {:reply, status[site_id], status}
  end
end

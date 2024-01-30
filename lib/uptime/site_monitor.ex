defmodule Uptime.SiteMonitor do
  use GenServer

  alias Uptime.Sites.Site
  alias Uptime.CheckHandler

  defstruct [:site, last_checked: nil, status: :unknown]

  def start(%Site{} = site) do
    GenServer.start_link(__MODULE__, site)
  end

  def status(pid) do
    GenServer.call(pid, :status)
  end

  def update_status(pid, status) do
    GenServer.cast(pid, {:update_status, status})
  end

  @impl true
  def init(%Site{} = site) do
    :timer.send_interval(5000, :check)
    {:ok, %__MODULE__{site: site}}
  end

  @impl true
  def handle_call(:status, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_info(:check, state) do
    site_monitor_pid = self()
    CheckHandler.check(state.site, site_monitor_pid)
    {:noreply, state}
  end

  @impl true
  def handle_cast({:update_status, {checked_at, results}}, state) do
    state =
      state
      |> Map.put(:last_checked, checked_at)
      |> Map.put(:status, results)

    {:noreply, state}
  end

  @impl true
  def handle_cast({:check_results, checked_at, status}, state) do
    state =
      state
      |> Map.put(:last_checked, checked_at)
      |> Map.put(:status, status)

    {:noreply, state}
  end
end

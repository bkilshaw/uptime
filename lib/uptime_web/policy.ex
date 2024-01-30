defmodule UptimeWeb.Policy do
  @moduledoc """
  Authorization policy for Uptime.
  """

  alias Phoenix.LiveView.Socket
  alias Plug.Conn

  alias Uptime.Users.User
  alias Uptime.Sites.Site

  @type user :: User.t() | Conn.t() | Socket.t()

  @doc """
  Checks user authorization for an action on a resource.
  Accepts a `User`, `Conn`, or `Socket` struct for the user.
  """
  @spec authorize(user(), atom(), term()) :: :ok | {:error, reason :: atom()}
  def authorize(user, action, resource) do
    if can?(user, action, resource) do
      :ok
    else
      {:error, :forbidden}
    end
  end

  @doc """
  Returns if a user is authorized to perform the action or not.
  Accepts a `User`, `Conn`, or `Socket` struct for the user.
  """
  @spec can?(user(), atom(), any()) :: boolean()
  def can?(user, action, resource)

  # ----------------------------------------------------------------------------
  # Extract user from Conn and Socket
  # ----------------------------------------------------------------------------

  def can?(%Conn{assigns: %{current_user: user}}, action, resource) do
    can?(user, action, resource)
  end

  def can?(%Socket{assigns: %{current_user: user}}, action, resource) do
    can?(user, action, resource)
  end

  # ----------------------------------------------------------------------------
  # Sites
  # ----------------------------------------------------------------------------

  def can?(user, :view, %Site{} = site) do
    user.user_id == site.user_id
  end

  def can?(user, :edit, %Site{} = site) do
    user.user_id == site.user_id
  end

  def can?(user, :delete, %Site{} = site) do
    user.user_id == site.user_id
  end

  # ----------------------------------------------------------------------------
  # Catch-all fallback. Fails.
  # ----------------------------------------------------------------------------

  def can?(_user, _action, _resource), do: false
end

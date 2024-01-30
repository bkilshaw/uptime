defmodule Uptime.Sites.Site do
  use Ecto.Schema
  import Ecto.Changeset

  alias Uptime.Users.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @type t :: %__MODULE__{
          id: String.t(),
          url: String.t(),
          user_id: String.t(),
          user: User.t() | Ecto.Association.NotLoaded.t(),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  schema "sites" do
    field :url, :string
    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(site, attrs) do
    site
    |> cast(attrs, [:url])
    |> validate_required([:url])
  end
end

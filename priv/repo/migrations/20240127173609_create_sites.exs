defmodule Uptime.Repo.Migrations.CreateSites do
  use Ecto.Migration

  def change do
    create table(:sites, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :url, :string, null: false
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:sites, [:user_id])
  end
end

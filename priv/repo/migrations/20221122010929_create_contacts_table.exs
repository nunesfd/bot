defmodule DevtipsBot.Repo.Migrations.CreateContactsTable do
  use Ecto.Migration

  def change do
    create table(:contacts, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :external_id, :string
      add :name, :string
      add :profile_picture, :string, null: true
      add :newsletter_active_in, :timestamp, null: true
      timestamps()
    end
  end
end

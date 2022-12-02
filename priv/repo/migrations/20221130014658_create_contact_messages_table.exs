defmodule DevtipsBot.Repo.Migrations.CreateContactMessagesTable do
  use Ecto.Migration

  def change do
    create table(:contact_messages, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :contact_id, :string
      add :message, :text
      timestamps()
    end
  end
end

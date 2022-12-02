defmodule DevtipsBot.ContactMessage do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}

  schema "contact_messages" do
    field :contact_id, :string
    field :message, :string
    timestamps()
  end

  def build(params) do
    params
    |> changeset()
    |> apply_action(:new_message)
  end

  @required_params [:contact_id, :message]
  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_params)
    |> validate_required(@required_params)
  end

end

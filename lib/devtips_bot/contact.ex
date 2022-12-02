defmodule DevtipsBot.Contact do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}

  schema "contacts" do
    field :name, :string
    field :external_id, :string
    field :profile_picture, :string
    field :newsletter_active_in, :utc_datetime
    timestamps()
  end

  def build(params) do
    params
    |> changeset()
    |> apply_action(:new_contact)
  end

  @required_params [:name, :external_id]
  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_params)
    |> validate_required(@required_params)
  end

  def changeset(contact, params) do
    contact
    |> cast(params, [:name, :profile_picture, :newsletter_active_in])
  end

end

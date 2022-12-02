defmodule DevtipsBot.InputMessage do

  use Ecto.Schema
  import Ecto.Changeset

  @required_params [:external_id, :created_at, :message]

  embedded_schema do
    field :external_id, :string
    field :created_at, :string
    field :message, :string

    embeds_one :contact_info, Child do
      field :external_id, :string
      field :name,  :string
    end
  end

  def build(params) do
    changeset(params)
    |> apply_action(:new_message)
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> cast_embed(:contact_info, with: &contact_info_changeset/2)
  end

  defp contact_info_changeset(schema, params) do
    schema
    |> cast(params, [:external_id, :name])
    |> validate_required([:external_id, :name])
  end

end

defmodule DevtipsBot.Session do

  use Ecto.Schema
  import Ecto.Changeset

  @required_params [
    :created_at,
    :contact_id,
    :contact_name,
    :external_contact_id
  ]

  embedded_schema do
    field :created_at, :utc_datetime
    field :contact_id, :string
    field :contact_name, :string
    field :external_contact_id, :string

    embeds_one :flow, Flow do
      field :next_flow, :string
      field :next_action, :string
      field :last_action_in, :utc_datetime
    end

  end

  def build(params) do
    changeset(params)
    |> apply_action(:new_session)
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> cast_embed(:flow, with: &flow_changeset/2)
    |> generate_id()
  end

  defp flow_changeset(schema, params) do
    schema
    |> cast(params, [:next_flow, :next_action, :last_action_in])
    |> validate_required([:next_flow, :next_action, :last_action_in])
  end

  defp generate_id(%Ecto.Changeset{valid?: true, changes: changes} = changeset) do
    change(changeset, %{id: "session_#{changes.external_contact_id}"})
  end

  defp generate_id(changeset), do: changeset

end

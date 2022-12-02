defmodule DevtipsBot.Contact.ChangeName do

  alias DevtipsBot.{Repo, Contact}
  alias Ecto.UUID

  def call(contact_id, name) do

    case UUID.cast(contact_id) do
      :error -> {:error, "invalid contact_id format"}
      {:ok, _uuid } -> update(contact_id, name)
    end
  end

  defp update(contact_id, name) do
    case Repo.get(Contact, contact_id) do
      nil -> {:error, "Contact not found!"}
      contact -> change_contact_name(contact, name)
    end
  end

  defp change_contact_name(contact, name) do
    contact
    |> Contact.changeset(%{name: name})
    |> Repo.update()
  end

end

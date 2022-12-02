defmodule DevtipsBot.Contact.ChangeNewsletter do

  alias DevtipsBot.{Repo, Contact}
  alias Ecto.UUID

  def call(contact_id, active_or_inactive) do

    case UUID.cast(contact_id) do
      :error -> {:error, "invalid contact_id format"}
      {:ok, _uuid } -> update(contact_id, active_or_inactive)
    end
  end

  defp update(contact_id, active_or_inactive) do
    case Repo.get(Contact, contact_id) do
      nil -> {:error, "Contact not found!"}
      contact -> change_newsletter(contact, active_or_inactive)
    end
  end

  defp change_newsletter(contact, :true) do
    contact
    |> Contact.changeset(%{newsletter_active_in: DateTime.utc_now()})
    |> Repo.update()
  end

  defp change_newsletter(contact, :false) do
    contact
    |> Contact.changeset(%{newsletter_active_in: nil})
    |> Repo.update()
  end

end

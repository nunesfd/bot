defmodule DevtipsBot.Contact.GetByExternalId do
  alias DevtipsBot.{Contact, Repo}

  def call(external_id) do
    get_by_external_id(external_id)
  end

  defp get_by_external_id(external_id) do
    case Repo.get_by(Contact, [external_id: external_id]) do
      nil -> {:error, "Contact not found!"}
      contact -> {:ok, contact}
    end
  end
end

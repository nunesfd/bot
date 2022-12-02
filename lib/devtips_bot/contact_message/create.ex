defmodule DevtipsBot.ContactMessage.Create do

  alias DevtipsBot.{Repo, ContactMessage}

  def call(params) do
    params
    |> ContactMessage.build()
    |> create_contact_message()
  end

  defp create_contact_message({:ok, struct}), do: Repo.insert(struct)
  defp create_contact_message({:error, _changeset} = error), do: error

end

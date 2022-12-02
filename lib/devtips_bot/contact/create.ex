defmodule DevtipsBot.Contact.Create do

  alias DevtipsBot.{Repo, Contact}

  def call(params) do
    params
    |> Contact.build()
    |> create_contact()
  end

  defp create_contact({:ok, struct}), do: Repo.insert(struct)
  defp create_contact({:error, _changeset} = error), do: error

end

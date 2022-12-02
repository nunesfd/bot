defmodule DevtipsBot.Session.Create do

  alias DevtipsBot.Session

  def call(params) do
    params
    |> Session.build()
    |> create_session()
  end

  defp create_session({:ok, session}) do
    DevtipsBot.App.Cache.put(session.id, session)
    {:ok, session}
  end

  defp create_session({:error, _changeset} = error), do: error

end

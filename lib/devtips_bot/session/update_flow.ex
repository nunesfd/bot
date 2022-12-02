defmodule DevtipsBot.Session.UpdateFlow do

  def call(session, next_flow, next_action) do

    new_flow = %{session.flow | next_flow: next_flow, next_action: next_action, last_action_in: DateTime.utc_now() }
    session = %{session | flow: new_flow}

    DevtipsBot.App.Cache.put(session.id, session)
    {:ok, session}
  end

  # defp update_flow({:ok, session}) do
  #   DevtipsBot.App.Cache.get(key, session)
  #   {:ok, session}

  #   case  do
  #     {:ok, session} ->
  #   end

  # end

  # defp create_session({:error, _changeset} = error), do: error

end

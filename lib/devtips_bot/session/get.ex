defmodule DevtipsBot.Session.Get do

  alias DevtipsBot.Session

  def call(session_id) do
    get_session(session_id)
  end

  defp get_session(session_id) do
    key = "session_" <> session_id
    DevtipsBot.App.Cache.get(key)
  end

end

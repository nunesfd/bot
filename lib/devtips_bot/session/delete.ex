defmodule DevtipsBot.Session.Delete do

  alias DevtipsBot.App.Cache

  def call(session) do
    Cache.del(session.id)
  end

end

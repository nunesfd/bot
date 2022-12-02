defmodule DevtipsBot.Flow.Manager do

  alias DevtipsBot.Flow.ReceiveNews
  alias DevtipsBot.Flow.TalkTeam
  alias DevtipsBot.Flow.ChangeContactName
  alias DevtipsBot.Flow.FunMessage
  alias DevtipsBot.Flow.Main

  def go_to("main", action, message, session) do
    Main.run(action, message, session)
  end

  def go_to("receive_news", action, message, session) do
    ReceiveNews.run(action, message, session)
  end

  def go_to("talk_team", action, message, session) do
    TalkTeam.run(action, message, session)
  end

  def go_to("change_contact_name", action, message, session) do
    ChangeContactName.run(action, message, session)
  end

  def go_to("fun_message", action, message, session) do
    FunMessage.run(action, message, session)
  end

end

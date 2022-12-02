defmodule DevtipsBot.Flow.TalkTeam do

  alias DevtipsBot.Session
  alias DevtipsBot.ContactMessage
  alias DevtipsBot.Wpp

  def run("init", message, session) do
    send_message_talk_team(message, session)
    Session.UpdateFlow.call(session, "talk_team", "input_message")
  end

  def run("input_message", message, session) do
    save_contact_message(message, session)
    Session.Delete.call(session)
  end

  defp send_message_talk_team(_message, session) do
    text = "Pode falar vou enviar tudo para equipe:"
    Wpp.Api.send_text_message(session.external_contact_id, text)
  end

  defp save_contact_message(message, session) do
    %{message: message_received} = message

    %{
      contact_id: contact_id,
      contact_name: contact_name,
      external_contact_id: external_contact_id
    } = session

    ContactMessage.Create.call(%{
      contact_id: contact_id,
      message: message_received,
    })

    text = "Prontinho, *#{contact_name}*, já envie sua mensagem para equipe *DEVTIPS*, logo eles te respondem!"
    Wpp.Api.send_text_message(external_contact_id, text)
  end

end

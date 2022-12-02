defmodule DevtipsBot.Flow.ChangeContactName do

  alias DevtipsBot.Session
  alias DevtipsBot.Wpp
  alias DevtipsBot.Contact

  def run("init", message, session) do
    send_change_your_name(message, session)
    Session.UpdateFlow.call(session, "change_contact_name", "input_change_your_name")
  end

  def run("input_change_your_name", message, session) do
    %{message: name} = message
    %{contact_id: contact_id, external_contact_id: external_contact_id} = session

    Contact.ChangeName.call(contact_id, name)
    text = "Pronto, a partir de agora vou te chamar de *#{name}*"
    Wpp.Api.send_text_message(external_contact_id, text)
    Session.Delete.call(session)
  end

  defp send_change_your_name(_message, session) do

    %{
      contact_name: contact_name,
      external_contact_id: external_contact_id,
    } = session

    text = "Nossa desculpe, estava te chamando de *#{contact_name}*. Me fala como quer eu te chame?"
    Wpp.Api.send_text_message(external_contact_id, text)
  end
end

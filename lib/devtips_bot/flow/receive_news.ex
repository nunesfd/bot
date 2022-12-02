defmodule DevtipsBot.Flow.ReceiveNews do

  alias DevtipsBot.Session
  alias DevtipsBot.Wpp
  alias DevtipsBot.Contact

  def run("init", message, session) do
    send_message(message, session)
  end

  def run("confirm_subscribe", message, session) do
    Session.Delete.call(session)

    case confirme_response(:subscribe, message, session) do
      {:ok} -> Contact.ChangeNewsletter.call(session.contact_id, true)
      {:nomatch} -> {:ok}
    end
  end

  def run("confirm_unsubscribe", message, session) do
    Session.Delete.call(session)

    case confirme_response(:unsubscribe, message, session) do
      {:ok} -> Contact.ChangeNewsletter.call(session.contact_id, false)
      {:nomatch} -> {:ok}
    end
  end

  defp send_message(message, session) do
    %{external_contact_id: external_contact_id} = session
    {:ok, contact} = Contact.GetByExternalId.call(external_contact_id)

    case contact.newsletter_active_in == nil do
      true -> send_menu_confirm(:subscribe, message, session)
      false -> send_menu_confirm(:unsubscribe, message, session)
    end

  end

  defp send_menu_confirm(:subscribe, _message, session) do
    menu = %{
      title: "Legal! quer ficar por dentro das novidades do *DEVTIPS*?",
      options: [
        "*1* - Sim, eu quero!",
        "*2* - Agora não"
      ]
    }

    Wpp.Api.send_menu_message(session.external_contact_id, menu)
    Session.UpdateFlow.call(session, "receive_news", "confirm_subscribe")
  end

  defp send_menu_confirm(:unsubscribe, _message, session) do
    %{contact_name: contact_name} = session
    menu = %{
      title: "*#{contact_name}* você já está inscrito.\nQuer parar de receber as novidades do *DEVTIPS* 🥺?",
      options: [
        "1 - Sim",
        "2 - Não"
      ]
    }

    Wpp.Api.send_menu_message(session.external_contact_id, menu)
    Session.UpdateFlow.call(session, "receive_news", "confirm_unsubscribe")
  end

  defp confirme_response(:subscribe, message, session) do
    %{message: option_selected} = message
    cond do
      String.match?(option_selected, ~r/^1$|Sim|Quero/i) ->
        send_change_newsletter(:subscribe, message, session)
      true -> send_not_change_newsletter(:subscribe, message, session)
    end
  end

  defp confirme_response(:unsubscribe, message, session) do

    %{message: option_selected} = message

    cond do
      String.match?(option_selected, ~r/^1$|Sim|Sair/i) ->
        send_change_newsletter(:unsubscribe, message, session)
      true -> send_not_change_newsletter(:unsubscribe, message, session)
    end
  end

  defp send_change_newsletter(:subscribe, _message, session) do

    %{contact_name: contact_name} = session

    text = "Legal *#{contact_name}* 😁\nAgora quando tiver novidades no *DEVTIPS* eu te envio aqui!"
    Wpp.Api.send_text_message(session.external_contact_id, text)
    {:ok}
  end

  defp send_change_newsletter(:unsubscribe, _message, session) do
    %{contact_name: contact_name} = session

    text = "Poxa que pena #{contact_name} 😭\nAgora não posso mais te enviar as novidades do *DEVTIPS*"
    Wpp.Api.send_text_message(session.external_contact_id, text)
    {:ok}
  end

  defp send_not_change_newsletter(:subscribe, _message, session) do
    text = "Sério? 😦 não quer receber as novidades?\nTudo bem, se mudar ideia é só falar comigo 🙂"
    Wpp.Api.send_text_message(session.external_contact_id, text)
    {:nomatch}
  end

  defp send_not_change_newsletter(:unsubscribe, _message, session) do
    text = "😱 Ufa! que susto, ainda bem que você não confirmou"
    Wpp.Api.send_text_message(session.external_contact_id, text)
    {:nomatch}
  end

end

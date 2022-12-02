defmodule DevtipsBot.Flow.Main do

  alias DevtipsBot.Flow.Manager
  alias DevtipsBot.Session
  alias DevtipsBot.Wpp

  def run("init", message, session) do
    send_welcome_message(message, session)
    send_menu_options(message, session)
  end

  def run("select_menu", message, session) do
    select_menu_options(message, session)
  end

  defp send_welcome_message(_message, session) do
    %{
      contact_name: contact_name,
      external_contact_id: external_contact_id,
    } = session

    text = "Olá *#{contact_name}*!\nSou o bot da *DEVTIPS*, como posso te ajudar?"
    Wpp.Api.send_text_message(external_contact_id, text)
  end

  defp send_menu_options(_message, session) do

    %{
      external_contact_id: external_contact_id,
    } = session

    menu = %{
      title: "*Escolhe uma das opções:*",
      options: [
        "*1* - Receber novidades",
        "*2* - Falar com a equipe DEVTIPS",
        "*3* - Alterar meu nome",
        "*4* - Estou só olhando"
      ]
    }

    Wpp.Api.send_menu_message(external_contact_id, menu)
    Session.UpdateFlow.call(session, "main", "select_menu")
  end

  defp select_menu_options(message, session) do

    %{message: option_selected } = message

    cond do
      String.match?(option_selected, ~r/^1$|Receber|Novidades|News/i) ->
        Manager.go_to("receive_news", "init", message, session)
      String.match?(option_selected, ~r/^2$|Falar|Equipe/i) ->
        Manager.go_to("talk_team", "init", message, session)
      String.match?(option_selected, ~r/^3$|Alterar/i) ->
        Manager.go_to("change_contact_name", "init", message, session)
      String.match?(option_selected, ~r/^4$|Olhando/i) ->
        Manager.go_to("fun_message", "init", message, session)
      true -> invalid_option_selected(message, session)
    end
  end

  defp invalid_option_selected(message, session) do
    %{ message: message } = message
    msg = String.slice(message, 0, 20)

    text = "Desculpe não conseguir te entender\n"
    <> "o que quer dizer com *#{msg}*?\n"
    <> "No momento só consigo entender as opções do menu"

    Wpp.Api.send_text_message(session.external_contact_id, text)
    send_menu_options(message, session)
  end

end

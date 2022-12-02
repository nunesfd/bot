defmodule DevtipsBot.Flow.FunMessage do

  alias DevtipsBot.Wpp
  alias DevtipsBot.Session

  def run("init", message, session) do
    send_fun_message(message, session)
    Session.Delete.call(session)
  end

  defp send_fun_message(_message, session) do
    %{external_contact_id: external_contact_id} = session
    text = random_message(session)
    Wpp.Api.send_text_message(external_contact_id, text)
  end

  defp random_message(session) do
    [:a, :b, :c]
      |> Enum.random()
      |> fun_message(session)
  end

  defp fun_message(:a, _session) do
    "Hummm curioso em? Tudo bem fique a vontade!"
  end

  defp fun_message(:b, session) do
    %{contact_name: contact_name} = session
    "Ei *#{contact_name}* posso te contar um segredo? Sabia que sou feito em elixir?"
  end

  defp fun_message(:c, session) do
    %{contact_name: contact_name} = session
    "*#{contact_name}* manda seu feedback pra gente!"
  end

end

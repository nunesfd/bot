defmodule DevtipsBot.Wpp.Api do

  @api_url "http://devtips-wpp:3001"
  @headers [{"Content-type", "application/json"}]

  def send_text_message(jid, text) do
    url = @api_url <> "/send-message-text"

    body = Poison.encode!(%{
      jId: jid,
      message: text,
    })

    HTTPoison.post(url, body, @headers)
    |> response()

  end

  def send_menu_message(jid, %{title: title, options: options}) do
    text = title <> "\n\n" <> Enum.join(options, "\n")
    send_text_message(jid, text)
  end

  defp response({:ok, %{status_code: 200, body: body}}) do
    Poison.decode!(body)
  end

  defp response({:ok, %{status_code: 404}}) do
    {:error, "Not found"}
  end

  defp response({:error, %{reason: reason}}) do
    {:error, reason}
  end

end

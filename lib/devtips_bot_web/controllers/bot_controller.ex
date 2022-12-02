defmodule DevtipsBotWeb.BotController do

  use DevtipsBotWeb, :controller

  def new_message(conn, params) do
    DevtipsBot.process_message(params)
    |> handle_response(conn)
  end

  defp handle_response({:ok, _msg}, conn) do
    json(conn, %{
      accept: true
    })
  end

  defp handle_response({:error, _changeset}, conn) do
    conn = put_status(conn, :bad_request)
    json(conn, %{message: "Dados inválidos"})
  end

end

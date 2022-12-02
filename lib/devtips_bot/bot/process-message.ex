defmodule DevtipsBot.Bot.ProcessMessage do

  alias DevtipsBot.InputMessage
  alias DevtipsBot.Session
  alias DevtipsBot.Contact
  alias DevtipsBot.Flow

  def call(params) do
    params
    |> InputMessage.build()
    |> process_message()
  end

  defp process_message({:ok, message = %InputMessage{}}) do
    {:ok, session} = get_or_create_session(message)
    Flow.Manager.go_to(session.flow.next_flow, session.flow.next_action, message, session)
    {:ok, message}
  end

  defp process_message({:error, _changeset} = error), do: error

  defp get_or_create_session(message = %InputMessage{}) do
    result = Session.Get.call(message.contact_info.external_id)

    case result do
      {:ok, nil} ->
        case get_or_create_contact(message) do
          {:ok, contact} -> create_session(message, contact)
          {:error, reason} -> {:error, reason}
        end
      {:ok, session} -> {:ok, session}
      {:error, reason} -> {:error, reason}
    end

  end

  defp create_session(message = %InputMessage{}, contact = %Contact{}) do

    Session.Create.call(%{
      created_at: message.created_at,
      contact_id: contact.id,
      contact_name: contact.name,
      external_contact_id: message.contact_info.external_id,
      flow: %{
        next_flow: "main",
        next_action: "init",
        last_action_in: DateTime.utc_now(),
      }
    })
  end

  defp get_or_create_contact(message = %InputMessage{}) do
    result = Contact.GetByExternalId.call(message.contact_info.external_id)

    case result do
      {:error, _reason} -> create_contact(message)
      {:ok, contact} -> {:ok, contact}
    end
  end

  defp create_contact(message = %InputMessage{}) do
    Contact.Create.call(%{
      "name" => message.contact_info.name,
      "external_id" => message.contact_info.external_id
    })
  end

end

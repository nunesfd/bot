defmodule DevtipsBot do

  alias DevtipsBot.{Bot, Contact}

  defdelegate process_message(params), to: Bot.ProcessMessage, as: :call

  defdelegate create_contact(params), to: Contact.Create, as: :call


end

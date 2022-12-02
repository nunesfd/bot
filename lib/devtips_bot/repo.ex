defmodule DevtipsBot.Repo do
  use Ecto.Repo,
    otp_app: :devtips_bot,
    adapter: Ecto.Adapters.Postgres
end

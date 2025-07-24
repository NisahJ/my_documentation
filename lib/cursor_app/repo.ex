defmodule CursorApp.Repo do
  use Ecto.Repo,
    otp_app: :cursor_app,
    adapter: Ecto.Adapters.Postgres
end

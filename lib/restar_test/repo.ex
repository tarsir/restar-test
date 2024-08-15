defmodule RestarTest.Repo do
  use Ecto.Repo,
    otp_app: :restar_test,
    adapter: Ecto.Adapters.Postgres
end

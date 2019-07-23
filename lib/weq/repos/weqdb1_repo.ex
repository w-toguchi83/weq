defmodule Weq.Repos.Weqdb1Repo do
  use Ecto.Repo,
    otp_app: :weq,
    adapter: Ecto.Adapters.MyXQL,
    read_only: true
end

defmodule WeqWeb.PingController do
  @moduledoc """
  pingコントローラー.
  """

  use WeqWeb, :controller
  alias WeqWeb.Utils.ResponseUtil

  @doc """
  `pong` を返す
  """
  def index(conn, _params) do
    try do
      json(conn, %{message: "pong"})
    rescue
      e in RuntimeError -> ResponseUtil.error_json(conn, e.message)
    end
  end
end

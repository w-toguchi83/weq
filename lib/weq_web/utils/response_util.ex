defmodule WeqWeb.Utils.ResponseUtil do
  @moduledoc """
  レスポンスユーティリティーモジュール
  """

  import Phoenix.Controller, only: [json: 2]

  @doc """
  指定された `status` を設定して、エラーを表現するJSONを返す.
  """
  def error_json(conn, message, status \\ :internal_server_error) do
    conn
    |> Plug.Conn.put_status(status)
    |> json(%{error: message})
  end
end

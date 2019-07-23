defmodule Weq.Query.Executor do
  @moduledoc """
  クエリ実行モジュール.
  """

  alias Weq.Query.ResultFormatter
  alias Ecto.Adapters.SQL

  @doc """
  クエリを実行して結果を返す.
  結果が `:error` だった場合は `RuntimeError` を発生させる.
  """
  def execute(repo, query, bind_params \\ [], opts \\ []) do
    opts = if Keyword.has_key?(opts, :timeout) do
      opts
    else
      ## デフォルトのタイムアウト値を指定する
      ## バッチ処理での利用も想定して、タイムアウト値は長めに設定する
      Keyword.put_new(opts, :timeout, 3_000_000)
    end

    result = SQL.query(repo, query, bind_params, opts) |> ResultFormatter.format
    case result do
      {:ok, rows} -> rows
      {:error, message} -> raise RuntimeError, message: message
    end
  end
end

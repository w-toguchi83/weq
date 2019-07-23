defmodule WeqWeb.Fetcher.Parameter do
  @moduledoc """
  `fetch` APIパラメータモジュール.
  パラメータはJSONでリクエストされ、処理内では `Map` 型となる.
  example)
  %{
    "resource" => "dbname",
    "query"    => "SELECT * FROM table1 where id in (?, ?, ?) AND type = ?",
    "binds"    => [
      1,
      2,
      3,
      "hoge"
    ]
    "limit"   => 1000,
    "offset"  => 0,
    "explain" => false,
    "debug"   => false
  }

  必須項目は `resource` と `query` 
  """

  @default_offset 0
  @default_limit 1000
  @max_limit 1000
  @default_json_data %{
    "resource" => "",
    "query"    => "",
    "binds"    => [],
    "limit"    => @default_limit,
    "offset"   => @default_offset,
    "explain"  => false,
    "debug"    => false
  }

  @doc """
  クエリJSONデータを正規化して返す.
  """
  def normalize(json_data) when is_map(json_data) do
    query = json_data |> Map.get("query", "") |> String.trim

    json_data = if query === "" do
      Map.put(json_data, "query", "")
    else
      json_data
    end

    sub_normalize(Map.merge(@default_json_data, json_data))
  end

  # `resource` が空の場合はエラーにする
  defp sub_normalize(%{"resource" => ""}), do: raise ArgumentError, message: "resource is empty"

  # `query` が空の場合はエラーにする
  defp sub_normalize(%{"query" => ""}), do: raise ArgumentError, message: "query is empty"

  # クエリJSONデータを正規化して返す
  defp sub_normalize(%{
    "resource" => resource,
    "query"    => query,
    "binds"    => binds,
    "limit"    => limit,
    "offset"   => offset,
    "explain"  => explain,
    "debug"    => debug
  }) do
    valid_limit   = validate_and_get_limit(limit)
    valid_offset  = validate_and_get_offset(offset)
    valid_explain = validate_and_get_explain(explain)
    valid_debug   = validate_and_get_debug(debug)

    # 正規化したクエリJSONデータを返す
    %{
      "resource" => resource,
      "query"    => query,
      "binds"    => binds,
      "limit"    => valid_limit,
      "offset"   => valid_offset,
      "explain"  => valid_explain,
      "debug"    => valid_debug
    }
  end

  defp validate_and_get_limit(limit) when is_integer(limit) and 0 <= limit and limit <= @max_limit, do: limit
  defp validate_and_get_limit(_), do: @default_limit

  defp validate_and_get_offset(offset) when is_integer(offset) and 0 <= offset, do: offset
  defp validate_and_get_offset(_), do: @default_offset

  defp validate_and_get_explain(explain) when is_boolean(explain), do: explain
  defp validate_and_get_explain(_), do: false

  defp validate_and_get_debug(debug) when is_boolean(debug), do: debug
  defp validate_and_get_debug(_), do: false
end

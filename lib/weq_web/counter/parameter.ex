defmodule WeqWeb.Counter.Parameter do
  @moduledoc """
  `count` APIパラメータモジュール.
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
    "debug"   => false
  }

  必須項目は `resource` と `query` 
  """

  @default_json_data %{
    "resource" => "",
    "query"    => "",
    "binds"    => [],
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
    "debug"    => debug
  }) do
    valid_debug   = validate_and_get_debug(debug)

    # 正規化したクエリJSONデータを返す
    %{
      "resource" => resource,
      "query"    => query,
      "binds"    => binds,
      "debug"    => valid_debug
    }
  end

  defp validate_and_get_debug(debug) when is_boolean(debug), do: debug
  defp validate_and_get_debug(_), do: false
end

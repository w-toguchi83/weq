defmodule WeqWeb.Describer.Parameter do
  @moduledoc """
  `desc` APIパラメータモジュール.
  パラメータはJSONでリクエストされ、処理内では `Map` 型となる.
  example)
  %{
    "resource" => "dbname",
    "table"    => "tbl1"
  }
  """

  @default_json_data %{
    "resource" => "",
    "table"    => ""
  }

  @doc """
  クエリJSONデータを正規化して返す.
  """
  def normalize(json_data) when is_map(json_data) do
    sub_normalize(Map.merge(@default_json_data, json_data))
  end

  # `resource` が空の場合はエラーにする
  defp sub_normalize(%{"resource" => ""}), do: raise ArgumentError, message: "resource is empty"

  # `table` が空の場合はエラーにする
  defp sub_normalize(%{"table" => ""}), do: raise ArgumentError, message: "table is empty"

  # クエリJSONデータを正規化して返す
  defp sub_normalize(%{
    "resource" => _resource,
    "table"    => _table
  } = json_data), do: json_data

end

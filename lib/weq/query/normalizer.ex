defmodule Weq.Query.Normalizer do
  @moduledoc """
  クエリ正規化モジュール.
  """

  alias Weq.Query.Tokenizer

  @doc """
  `query` と `bind_params` を正規化して返す.
  """
  def normalize_query_and_bind_params(query, bind_params) when is_binary(query) do
    tokenized_query = Tokenizer.tokenize(query)
    normalized_query = normalize_query(tokenized_query, bind_params)
    normalized_bind_params = normalize_bind_params(tokenized_query, bind_params)

    {normalized_query, normalized_bind_params}
  end

  @doc """
  `query` を正規化した文字列にして返す.
  """
  def normalize_query(query, bind_params) when is_binary(query) do
    normalize_query(Tokenizer.tokenize(query), bind_params)
  end

  @doc """
  `query` を正規化した文字列にして返す.
  `bind_params` の型が `List` の場合は、単純に `query` を正規化して返す.
  """
  def normalize_query(query, bind_params) when is_list(query) and is_list(bind_params) do
    Enum.join(query, " ")
  end


  @doc """
  `query` を正規化した文字列にして返す.
  `bind_params` の型が `Map` の場合は、名前付きバインド変数として、正規化した文字列を返す.
  """
  def normalize_query(query, bind_params) when is_list(query) and is_map(bind_params) do
    ## 名前付きバインド変数の場合は "?" バインド変数に変換したものを返す
    ## バインド変数の値の型が `List` の場合は、 `List` の要素数分 "?"バインド変数を作成する
    token_list = for token <- query, do: (
      bind_name = get_bind_name(token)
      cond do
        bind_name === "" ->
          token
        Map.has_key?(bind_params, bind_name) -> (
            value = Map.get(bind_params, bind_name)
            if is_list(value) do
              ## 戻り値の例: ["?", "," "?", ",", "?"]
              String.duplicate(",?", length(value))
              |> String.split("")
              |> Enum.filter(fn it -> it !== "" end)
              |> (fn [_head | tail] -> tail end).()
            else
              "?"
            end
        )
        true ->
          ""
      end
    )

    token_list
    |> List.flatten
    |> Enum.join(" ")
  end

  @doc """
  `bind_params` が `List` 型の場合はそのまま返す.
  """
  def normalize_bind_params(_query, bind_params) when is_list(bind_params), do: bind_params

  @doc """
  `bind_params` を正規化した `List` にして返す.
  """
  def normalize_bind_params(query, bind_params) when is_binary(query) and is_map(bind_params) do
    normalize_bind_params(Tokenizer.tokenize(query), bind_params)
  end

  @doc """
  `Map` 型の `bind_params` を正規化した `List` にして返す.
  """
  def normalize_bind_params(query, bind_params) when is_list(query) and is_map(bind_params) do
    collect_bind_params(query, bind_params, [])
  end

  # 名前付きバインド変数からプレフィックスの ":" を取り除いたものを返す.
  defp get_bind_name(str) do
    if String.starts_with?(str, ":") do
      String.slice(str, 1, String.length(str))
    else
      ""
    end
  end

  # 集めたバインド変数のデータを返す.
  defp collect_bind_params([], _bind_param_map, holder), do: holder

  # バインド変数を集めて返す.
  defp collect_bind_params([head | tail], bind_param_map, holder) do
    bind_name = get_bind_name(head)
    cond do
      bind_name !== "" and Map.has_key?(bind_param_map, bind_name) -> (
          value = Map.get(bind_param_map, bind_name)
          if is_list(value) do
            collect_bind_params(tail, bind_param_map, holder ++ value)
          else
            collect_bind_params(tail, bind_param_map, holder ++ [value])
          end
      )
      true ->
        collect_bind_params(tail, bind_param_map, holder)
    end
  end
end

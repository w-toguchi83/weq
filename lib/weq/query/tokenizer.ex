defmodule Weq.Query.Tokenizer do
  @moduledoc """
  クエリトークナイザーモジュール.
  """

  @one_token_map %{
    ")" => true,
    "," => true,
  }

  @doc """
  クエリ文字列をトークンリストに変換して返す.
  """
  def tokenize(query) do
    sub_tokenize(query, 0, [])
  end

  # トークナイズのサブ関数。トークンリストを返す.
  defp sub_tokenize(query, index, token_list) do
    {token, next_index} = get_token(query, index, [])

    cond do
      token === "" ->
        token_list
      token === " " ->
        sub_tokenize(query, next_index, token_list)
      true ->
        sub_tokenize(query, next_index, token_list ++ [token])
    end
  end

  # 文字列からトークンを抜き出して返す.
  defp get_token(query, index, box) do
    s = String.at(query, index)
    next_index = index + 1
    next_s = String.at(query, next_index)

    cond do
      is_nil(s) ->
        ## 文字列の終端を超えた
        {Enum.join(box), next_index}
      box === [] and Map.has_key?(@one_token_map, s) ->
        ## 1文字でトークンとして返すもの
        {s, next_index}
      box === [] and is_white_space(s) ->
        {" ", next_index}
      s === "(" and next_s === ":" ->
        ## '(' に続いて、名前付き変数が現れる場合はトークンを分割
        {Enum.join(box ++ [s]), next_index}
      s === "'" ->
        ## 文字列リテラルのはじまり
        get_token_of_literal(query, next_index, ["'"])
      Map.has_key?(@one_token_map, next_s) ->
        ## 次の文字が1文字トークンの場合はここまででトークンとして返す
        {Enum.join(box ++ [s]), next_index}
      !is_nil(next_s) and is_white_space(next_s) ->
        {Enum.join(box ++ [s]), next_index}
      true ->
        get_token(query, next_index, box ++ [s])
    end
  end

  # シングルクォートで囲まれた文字列リテラルのトークンを返す.
  defp get_token_of_literal(query, index, box) do
    s = String.at(query, index)
    prev_s = if 0 < index do
      String.at(query, index - 1)
    else
      ""
    end
    next_index = index + 1

    cond do
      s === "'" and prev_s !== "\\" ->
        {Enum.join(box ++ ["'"]), next_index}
      is_nil(s) ->
        {Enum.join(box), next_index}
      true ->
        get_token_of_literal(query, next_index, box ++ [s])
    end
  end

  # 空白文字列だった場合に `true` を返す
  defp is_white_space(it), do: String.match?(it, ~r/^[[:space:]]$/)
end

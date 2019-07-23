defmodule Weq.Query.NormalizerTest do
  use ExUnit.Case, async: true

  alias Weq.Query.Normalizer

  test "normalize_query_and_bind_params (1)" do
    query = "SELECT * FROM tbl WHERE id = ? AND del_flg = ?"
    bind_params = ["123456789", 0]

    {normalized_query, normalized_bind_params} = Normalizer.normalize_query_and_bind_params(query, bind_params)

    assert query === normalized_query
    assert bind_params === normalized_bind_params
  end

  test "normalize_query_and_bind_params (2)" do
    query = "SELECT * FROM tbl WHERE id = :id AND del_flg = :del_flg"
    bind_params = %{
      "del_flg" => 0,
      "id" => "123456789"
    }

    {normalized_query, normalized_bind_params} = Normalizer.normalize_query_and_bind_params(query, bind_params)

    assert "SELECT * FROM tbl WHERE id = ? AND del_flg = ?" === normalized_query
    assert ["123456789", 0] === normalized_bind_params
  end

  test "normalize_query_and_bind_params (3)" do
    query = "SELECT * FROM tbl WHERE id IN (:id_list) AND del_flg = :del_flg"
    bind_params = %{
      "id_list" => ["123", "456", "789"],
      "del_flg" => 0
    }

    {normalized_query, normalized_bind_params} = Normalizer.normalize_query_and_bind_params(query, bind_params)

    assert "SELECT * FROM tbl WHERE id IN ( ? , ? , ? ) AND del_flg = ?" === normalized_query
    assert ["123", "456", "789", 0] === normalized_bind_params
  end

  test "normalize_query_and_bind_params (4)" do
    ## 名前付きバインド変数の再利用
    query = "SELECT * FROM tbl WHERE id = :id OR (type = :type AND id != :id)"
    bind_params = %{
      "id" => "999",
      "type" => "hoge"
    }

    {normalized_query, normalized_bind_params} = Normalizer.normalize_query_and_bind_params(query, bind_params)

    assert "SELECT * FROM tbl WHERE id = ? OR (type = ? AND id != ? )" === normalized_query
    assert ["999", "hoge", "999"] === normalized_bind_params
  end
end

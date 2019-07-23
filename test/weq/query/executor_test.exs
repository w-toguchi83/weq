defmodule Weq.Query.ExecutorTest do
  use Weq.DataCase, async: true

  alias Weq.Query.Executor
  alias Weq.Repos.Weqdb1Repo

  test "execute (test rows count)" do
    query = "SELECT title FROM m_product"

    rows = Executor.execute(Weqdb1Repo, query)

    ## テストデータとして10件登録している
    assert 10 === Enum.count(rows)
  end

  test "execute (test row)" do
    query = "SELECT * FROM m_product WHERE series_id = ? AND deleted_at IS NULL"
    bind_params = ["2000"]

    rows = Executor.execute(Weqdb1Repo, query, bind_params)

    assert 1 === Enum.count(rows)

    row = List.first(rows)
    assert "シリーズ2商品タイトル1" === row["title"]
    assert "シリーズ2ショウヒンタイトル1" === row["title_ruby"]
    assert "1" === row["volume"]
    assert 380 === row["price"]
    assert "2019-07-22 10:30:43" === row["created_at"]
    assert "2019-07-22 10:30:43" === row["updated_at"]
    assert "0000-00-00 00:00:00" === row["deleted_at"]
  end

  test "execute (error)" do
    ## 存在しないテーブルをSELECT
    query = "SELECT * FROM abcxyz"

    assert_raise RuntimeError, fn ->
      Executor.execute(Weqdb1Repo, query)
    end
  end
end

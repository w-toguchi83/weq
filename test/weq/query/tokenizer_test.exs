defmodule Weq.Query.TokenizerTest do
  use ExUnit.Case, async: true

  alias Weq.Query.Tokenizer

  test "tokenize (1)" do
    query = "SELECT"
    assert ["SELECT"] === Tokenizer.tokenize(query)
  end

  test "tokenize (2)" do
    query = "SELECT * FROM tbl"
    assert ["SELECT", "*", "FROM", "tbl"] === Tokenizer.tokenize(query)
  end

  test "tokenize (3)" do
    query = "SELECT * FROM tbl WHERE id IN (1, 2, 3)"
    expected = ["SELECT", "*", "FROM", "tbl", "WHERE", "id", "IN", "(1", ",", "2", ",", "3", ")"]
    assert expected === Tokenizer.tokenize(query)
  end

  test "tokenize (4)" do
    query = "SELECT 'hoge' AS col1 FROM tbl WHERE id = 'piyo bar'   "
    expected = ["SELECT", "'hoge'", "AS", "col1", "FROM", "tbl", "WHERE", "id", "=", "'piyo bar'"]
    assert expected === Tokenizer.tokenize(query)
  end

  test "tokenize (5)" do
    query = "SELECT * FROM tbl WHERE id IN (:id_list)"
    expected = ["SELECT", "*", "FROM", "tbl", "WHERE", "id", "IN", "(", ":id_list", ")"]
    assert expected === Tokenizer.tokenize(query)
  end
end

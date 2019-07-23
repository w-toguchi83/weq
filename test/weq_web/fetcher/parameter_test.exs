defmodule WeqWeb.Fetcher.ParameterTest do
  use ExUnit.Case, async: true

  alias WeqWeb.Fetcher.Parameter;

  test "normalize return default" do
    json_data = %{
      "resource" => "dbname",
      "query"    => "SELECT * FROM tbl"
    }

    result = Parameter.normalize(json_data)

    assert result["resource"] === "dbname"
    assert result["query"] === "SELECT * FROM tbl"
    assert result["binds"] === []
    assert result["limit"] === 1000
    assert result["offset"] === 0
    assert result["explain"] === false
    assert result["debug"] === false
  end

  test "normalize" do
    json_data = %{
      "resource" => "dbname",
      "query"    => "SELECT * FROM tbl WHERE id IN (?, ?, ?)",
      "binds"    => [1, 2, 3],
      "limit"    => 150,
      "offset"   => 30,
      "explain"  => true,
      "debug"    => true
    }

    result = Parameter.normalize(json_data)

    assert result["resource"] === "dbname"
    assert result["query"] === "SELECT * FROM tbl WHERE id IN (?, ?, ?)"
    assert result["binds"] === [1, 2, 3]
    assert result["limit"] === 150
    assert result["offset"] === 30
    assert result["explain"] === true
    assert result["debug"] === true
  end

  test "error: resource is empty (1)" do
    json_data = %{
      "resource" => "",
      "query"    => "SELECT * FROM tbl"
    }

    assert_raise ArgumentError, "resource is empty", fn ->
      Parameter.normalize(json_data)
    end
  end

  test "error: resource is empty (2)" do
    json_data = %{
      "query"    => "SELECT * FROM tbl"
    }

    assert_raise ArgumentError, "resource is empty", fn ->
      Parameter.normalize(json_data)
    end
  end

  test "error: query is empty (1)" do
    json_data = %{
      "resource" => "dbname",
      "query"    => ""
    }

    assert_raise ArgumentError, "query is empty", fn ->
      Parameter.normalize(json_data)
    end
  end

  test "error: query is empty (2)" do
    json_data = %{
      "resource" => "dbname"
    }

    assert_raise ArgumentError, "query is empty", fn ->
      Parameter.normalize(json_data)
    end
  end
end

defmodule WeqWeb.FetchControllerTest do
  use WeqWeb.ConnCase, async: true

  test "POST /api/fetch (1)", %{conn: conn} do
    params = %{
      "resource" => "weqdb1",
      "query" => "SELECT * FROM m_product WHERE series_id = :series_id",
      "binds" => %{
        "series_id" => "3000",
      },
      "debug" => true
    }

    conn = post(conn, "/api/fetch", params)
    response = json_response(conn, 200)

    assert params["query"] === response["org_query"]
    assert params["binds"] === response["org_binds"]

    rows = response["rows"]
    assert 3 === Enum.count(rows)
  end

  test "POST /api/fetch (2)", %{conn: conn} do
    params = %{
      "resource" => "weqdb2",
      "query" => "SELECT SUM(price) AS total FROM t_sales"
    }

    conn = post(conn, "/api/fetch", params)
    response = json_response(conn, 200)
    
    rows = response["rows"]
    assert "4770" === List.first(rows)["total"]
  end
end

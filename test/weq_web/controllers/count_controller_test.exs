defmodule WeqWeb.CountControllerTest do
  use WeqWeb.ConnCase, async: true

  test "POST /api/count (1)", %{conn: conn} do
    params = %{
      "resource" => "weqdb1",
      "query" =>  "SELECT * FROM m_product"
    }
    conn = post(conn, "/api/count", params)
    assert json_response(conn, 200) === %{"count" => 10}
  end

  test "POST /api/count (2)", %{conn: conn} do
    params = %{
      "resource" => "weqdb1",
      "query" =>  "SELECT * FROM m_product WHERE series_id = :series_id",
      "binds" => %{
        "series_id" => "1000"
      }
    }
    conn = post(conn, "/api/count", params)
    assert json_response(conn, 200) === %{"count" => 5}
  end
end

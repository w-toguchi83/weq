defmodule WeqWeb.DescControllerTest do
  use WeqWeb.ConnCase, async: true

  test "POST /api/desc", %{conn: conn} do
    params = %{
      "resource" => "weqdb1",
      "table" => "m_product"
    }
    conn = post(conn, "/api/desc", params)
    response = json_response(conn, 200)

    assert "m_product" === response["table"]
    assert 9 === Enum.count(response["rows"])
  end
end

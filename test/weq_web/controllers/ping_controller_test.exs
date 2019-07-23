defmodule WeqWeb.PingControllerTest do
  use WeqWeb.ConnCase, async: true

  test "GET /api/ping", %{conn: conn} do
    conn = get(conn, "/api/ping")
    assert json_response(conn, 200) === %{"message" => "pong"}
  end
end

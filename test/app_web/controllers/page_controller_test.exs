defmodule AppWeb.PageControllerTest do
  use AppWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")

    assert html_response(conn, 200) =~
             "<h2 class=\"text-4xl tracking-tight\">\n      Faça login na sua conta\n   </h2>\n   "
  end
end

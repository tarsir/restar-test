defmodule RestarTestWeb.PageControllerTest do
  use RestarTestWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "Japanese Address Storage"
  end

  test "GET /api/", %{conn: conn} do
    conn = get(conn, ~p"/api/")
    assert json_response(conn, 200)["addresses"] == []
  end

  test "POST /api/addresses", %{conn: conn} do
    upload = %Plug.Upload{path: "test/data/test.csv", filename: "test.csv"}
    conn = post(conn, ~p"/api/addresses", %{"file" => upload})

    response = json_response(conn, 200)
    assert response["addresses"] != []
    assert response["result"]["status"] == "success"
  end

  test "DELETE /api/addresses", %{conn: conn} do
    upload = %Plug.Upload{path: "test/data/test.csv", filename: "test.csv"}
    conn = post(conn, ~p"/api/addresses", %{"file" => upload})
    response = json_response(conn, 200)
    assert response["addresses"] != []

    conn = delete(conn, ~p"/api/addresses")
    response = json_response(conn, 200)
    assert response["addresses"] == []
    assert response["result"]["status"] == "success"
  end
end

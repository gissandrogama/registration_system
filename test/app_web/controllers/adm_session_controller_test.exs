defmodule AppWeb.AdmSessionControllerTest do
  use AppWeb.ConnCase, async: true

  import App.AccountsFixtures

  setup do
    %{adm: adm_fixture()}
  end

  describe "GET /admins/log_in" do
    test "renders log in page", %{conn: conn} do
      conn = get(conn, Routes.adm_session_path(conn, :new))
      response = html_response(conn, 200)
      assert response =~ "<h1>Log in</h1>"
      assert response =~ "Log in</a>"
      assert response =~ "Register</a>"
    end

    test "redirects if already logged in", %{conn: conn, adm: adm} do
      conn = conn |> log_in_adm(adm) |> get(Routes.adm_session_path(conn, :new))
      assert redirected_to(conn) == "/"
    end
  end

  describe "POST /admins/log_in" do
    test "logs the adm in", %{conn: conn, adm: adm} do
      conn =
        post(conn, Routes.adm_session_path(conn, :create), %{
          "adm" => %{"email" => adm.email, "password" => valid_adm_password()}
        })

      assert get_session(conn, :adm_token)
      assert redirected_to(conn) =~ "/"

      # Now do a logged in request and assert on the menu
      conn = get(conn, "/")
      response = html_response(conn, 200)
      assert response =~ adm.email
      assert response =~ "Settings</a>"
      assert response =~ "Log out</a>"
    end

    test "logs the adm in with remember me", %{conn: conn, adm: adm} do
      conn =
        post(conn, Routes.adm_session_path(conn, :create), %{
          "adm" => %{
            "email" => adm.email,
            "password" => valid_adm_password(),
            "remember_me" => "true"
          }
        })

      assert conn.resp_cookies["adm_remember_me"]
      assert redirected_to(conn) =~ "/"
    end

    test "emits error message with invalid credentials", %{conn: conn, adm: adm} do
      conn =
        post(conn, Routes.adm_session_path(conn, :create), %{
          "adm" => %{"email" => adm.email, "password" => "invalid_password"}
        })

      response = html_response(conn, 200)
      assert response =~ "<h1>Log in</h1>"
      assert response =~ "Invalid e-mail or password"
    end
  end

  describe "DELETE /admins/log_out" do
    test "logs the adm out", %{conn: conn, adm: adm} do
      conn = conn |> log_in_adm(adm) |> delete(Routes.adm_session_path(conn, :delete))
      assert redirected_to(conn) == "/"
      refute get_session(conn, :adm_token)
      assert get_flash(conn, :info) =~ "Logged out successfully"
    end

    test "succeeds even if the adm is not logged in", %{conn: conn} do
      conn = delete(conn, Routes.adm_session_path(conn, :delete))
      assert redirected_to(conn) == "/"
      refute get_session(conn, :adm_token)
      assert get_flash(conn, :info) =~ "Logged out successfully"
    end
  end
end

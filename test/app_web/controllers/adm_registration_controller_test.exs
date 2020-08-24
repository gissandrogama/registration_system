defmodule AppWeb.AdmRegistrationControllerTest do
  use AppWeb.ConnCase, async: true

  import App.AccountsFixtures

  describe "GET /admins/register" do
    test "renders registration page", %{conn: conn} do
      conn = get(conn, Routes.adm_registration_path(conn, :new))
      response = html_response(conn, 200)

      assert response =~
               "\n  <h1 class=\"text-4xl tracking-tight\">Registro de Administradores</h1>\n  "

      assert response =~
               "<p class=\"text-blue-500\">\n    <a href=\"/admins/log_in\">Acessar</a> |\n<a href=\"/admins/reset_password\">Esqueceu sua senha?</a>  </p>\n"
    end

    test "redirects if already logged in", %{conn: conn} do
      conn = conn |> log_in_adm(adm_fixture()) |> get(Routes.adm_registration_path(conn, :new))
      assert redirected_to(conn) == "/leader"
    end
  end

  describe "POST /admins/register" do
    @tag :capture_log
    test "creates account and logs the adm in", %{conn: conn} do
      name = unique_name()
      email = unique_adm_email()

      conn =
        post(conn, Routes.adm_registration_path(conn, :create), %{
          "adm" => %{"name" => name, "email" => email, "password" => valid_adm_password()}
        })

      assert get_session(conn, :adm_token)
      assert redirected_to(conn) =~ "/"

      # Now do a logged in request and assert on the menu
      conn = get(conn, "/")
      response = html_response(conn, 200)

      assert response =~
               "\n  <p class=\"alert alert-info\" role=\"alert\">Adm created successfully.</p>\n  "
    end

    test "render errors for invalid data", %{conn: conn} do
      conn =
        post(conn, Routes.adm_registration_path(conn, :create), %{
          "adm" => %{"email" => "with spaces", "password" => "too"}
        })

      response = html_response(conn, 200)

      assert response =~
               "<h1 class=\"text-4xl tracking-tight\">Registro de Administradores</h1>\n "

      assert response =~ "must have the @ sign and no spaces"
      assert response =~ "should be at least 6 character"
    end
  end
end

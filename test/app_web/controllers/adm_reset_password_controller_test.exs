defmodule AppWeb.AdmResetPasswordControllerTest do
  use AppWeb.ConnCase, async: true

  alias App.Accounts
  alias App.Repo
  import App.AccountsFixtures

  setup do
    %{adm: adm_fixture()}
  end

  describe "GET /admins/reset_password" do
    test "renders the reset password page", %{conn: conn} do
      conn = get(conn, Routes.adm_reset_password_path(conn, :new))
      response = html_response(conn, 200)

      assert response =~
               "<div class=\"px-4 py-6 sm:px-0\"><main role=\"main\" class=\"container mx-auto mb-8 px-4 max-w-6xl\">\n  <p class=\"alert alert-info\" role=\"alert\"></p>\n  <p class=\"alert alert-danger\" role=\"alert\"></p>\n<div class=\"text-center mt-24\">\n  <h1 class=\"text-4xl tracking-tight\">Gerar nova senha</h1>\n  <p class=\"text-blue-500\">\n    <a href=\"/admins/log_in\">Acessar</a> |\n<a href=\"/admins/reset_password\">Esqueceu sua senha?</a>  </p>\n</div>\n\n"
    end
  end

  describe "POST /admins/reset_password" do
    @tag :capture_log
    test "sends a new reset password token", %{conn: conn, adm: adm} do
      conn =
        post(conn, Routes.adm_reset_password_path(conn, :create), %{
          "adm" => %{"email" => adm.email}
        })

      assert redirected_to(conn) == "/"
      assert get_flash(conn, :info) =~ "If your e-mail is in our system"
      assert Repo.get_by!(Accounts.AdmToken, adm_id: adm.id).context == "reset_password"
    end

    test "does not send reset password token if email is invalid", %{conn: conn} do
      conn =
        post(conn, Routes.adm_reset_password_path(conn, :create), %{
          "adm" => %{"email" => "unknown@example.com"}
        })

      assert redirected_to(conn) == "/"
      assert get_flash(conn, :info) =~ "If your e-mail is in our system"
      assert Repo.all(Accounts.AdmToken) == []
    end
  end

  describe "GET /admins/reset_password/:token" do
    setup %{adm: adm} do
      token =
        extract_adm_token(fn url ->
          Accounts.deliver_adm_reset_password_instructions(adm, url)
        end)

      %{token: token}
    end

    test "renders reset password", %{conn: conn, token: token} do
      conn = get(conn, Routes.adm_reset_password_path(conn, :edit, token))
      assert html_response(conn, 200) =~ "<h1>Reset password</h1>"
    end

    test "does not render reset password with invalid token", %{conn: conn} do
      conn = get(conn, Routes.adm_reset_password_path(conn, :edit, "oops"))
      assert redirected_to(conn) == "/"
      assert get_flash(conn, :error) =~ "Reset password link is invalid or it has expired"
    end
  end

  describe "PUT /admins/reset_password/:token" do
    setup %{adm: adm} do
      token =
        extract_adm_token(fn url ->
          Accounts.deliver_adm_reset_password_instructions(adm, url)
        end)

      %{token: token}
    end

    test "resets password once", %{conn: conn, adm: adm, token: token} do
      conn =
        put(conn, Routes.adm_reset_password_path(conn, :update, token), %{
          "adm" => %{
            "password" => "new valid password",
            "password_confirmation" => "new valid password"
          }
        })

      assert redirected_to(conn) == Routes.adm_session_path(conn, :new)
      refute get_session(conn, :adm_token)
      assert get_flash(conn, :info) =~ "Password reset successfully"
      assert Accounts.get_adm_by_email_and_password(adm.email, "new valid password")
    end

    test "does not reset password on invalid data", %{conn: conn, token: token} do
      conn =
        put(conn, Routes.adm_reset_password_path(conn, :update, token), %{
          "adm" => %{
            "password" => "too",
            "password_confirmation" => "does not match"
          }
        })

      response = html_response(conn, 200)
      assert response =~ "<h1>Reset password</h1>"
      assert response =~ "should be at least 6 character(s)"
      assert response =~ "does not match password"
    end

    test "does not reset password with invalid token", %{conn: conn} do
      conn = put(conn, Routes.adm_reset_password_path(conn, :update, "oops"))
      assert redirected_to(conn) == "/"
      assert get_flash(conn, :error) =~ "Reset password link is invalid or it has expired"
    end
  end
end

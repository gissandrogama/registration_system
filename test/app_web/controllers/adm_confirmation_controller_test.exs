defmodule AppWeb.AdmConfirmationControllerTest do
  use AppWeb.ConnCase, async: true

  alias App.Accounts
  alias App.Repo
  import App.AccountsFixtures

  setup do
    %{adm: adm_fixture()}
  end

  describe "GET /adms/confirm" do
    test "renders the confirmation page", %{conn: conn} do
      conn = get(conn, Routes.adm_confirmation_path(conn, :new))
      response = html_response(conn, 200)
      assert response =~ "<h1>Resend confirmation instructions</h1>"
    end
  end

  describe "POST /adms/confirm" do
    @tag :capture_log
    test "sends a new confirmation token", %{conn: conn, adm: adm} do
      conn =
        post(conn, Routes.adm_confirmation_path(conn, :create), %{
          "adm" => %{"email" => adm.email}
        })

      assert redirected_to(conn) == "/"
      assert get_flash(conn, :info) =~ "If your e-mail is in our system"
      assert Repo.get_by!(Accounts.AdmToken, adm_id: adm.id).context == "confirm"
    end

    test "does not send confirmation token if account is confirmed", %{conn: conn, adm: adm} do
      Repo.update!(Accounts.Adm.confirm_changeset(adm))

      conn =
        post(conn, Routes.adm_confirmation_path(conn, :create), %{
          "adm" => %{"email" => adm.email}
        })

      assert redirected_to(conn) == "/"
      assert get_flash(conn, :info) =~ "If your e-mail is in our system"
      refute Repo.get_by(Accounts.AdmToken, adm_id: adm.id)
    end

    test "does not send confirmation token if email is invalid", %{conn: conn} do
      conn =
        post(conn, Routes.adm_confirmation_path(conn, :create), %{
          "adm" => %{"email" => "unknown@example.com"}
        })

      assert redirected_to(conn) == "/"
      assert get_flash(conn, :info) =~ "If your e-mail is in our system"
      assert Repo.all(Accounts.AdmToken) == []
    end
  end

  describe "GET /adms/confirm/:token" do
    test "confirms the given token once", %{conn: conn, adm: adm} do
      token =
        extract_adm_token(fn url ->
          Accounts.deliver_adm_confirmation_instructions(adm, url)
        end)

      conn = get(conn, Routes.adm_confirmation_path(conn, :confirm, token))
      assert redirected_to(conn) == "/"
      assert get_flash(conn, :info) =~ "Account confirmed successfully"
      assert Accounts.get_adm!(adm.id).confirmed_at
      refute get_session(conn, :adm_token)
      assert Repo.all(Accounts.AdmToken) == []

      conn = get(conn, Routes.adm_confirmation_path(conn, :confirm, token))
      assert redirected_to(conn) == "/"
      assert get_flash(conn, :error) =~ "Confirmation link is invalid or it has expired"
    end

    test "does not confirm email with invalid token", %{conn: conn, adm: adm} do
      conn = get(conn, Routes.adm_confirmation_path(conn, :confirm, "oops"))
      assert redirected_to(conn) == "/"
      assert get_flash(conn, :error) =~ "Confirmation link is invalid or it has expired"
      refute Accounts.get_adm!(adm.id).confirmed_at
    end
  end
end

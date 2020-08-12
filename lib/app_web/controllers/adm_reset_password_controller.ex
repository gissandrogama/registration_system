defmodule AppWeb.AdmResetPasswordController do
  use AppWeb, :controller

  alias App.Accounts

  plug :get_adm_by_reset_password_token when action in [:edit, :update]

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"adm" => %{"email" => email}}) do
    if adm = Accounts.get_adm_by_email(email) do
      Accounts.deliver_adm_reset_password_instructions(
        adm,
        &Routes.adm_reset_password_url(conn, :edit, &1)
      )
    end

    # Regardless of the outcome, show an impartial success/error message.
    conn
    |> put_flash(
      :info,
      "If your e-mail is in our system, you will receive instructions to reset your password shortly."
    )
    |> redirect(to: "/")
  end

  def edit(conn, _params) do
    render(conn, "edit.html", changeset: Accounts.change_adm_password(conn.assigns.adm))
  end

  # Do not log in the adm after reset password to avoid a
  # leaked token giving the adm access to the account.
  def update(conn, %{"adm" => adm_params}) do
    case Accounts.reset_adm_password(conn.assigns.adm, adm_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Password reset successfully.")
        |> redirect(to: Routes.adm_session_path(conn, :new))

      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  defp get_adm_by_reset_password_token(conn, _opts) do
    %{"token" => token} = conn.params

    if adm = Accounts.get_adm_by_reset_password_token(token) do
      conn |> assign(:adm, adm) |> assign(:token, token)
    else
      conn
      |> put_flash(:error, "Reset password link is invalid or it has expired.")
      |> redirect(to: "/")
      |> halt()
    end
  end
end

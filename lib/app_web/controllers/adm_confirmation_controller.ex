defmodule AppWeb.AdmConfirmationController do
  use AppWeb, :controller

  alias App.Accounts

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"adm" => %{"email" => email}}) do
    if adm = Accounts.get_adm_by_email(email) do
      Accounts.deliver_adm_confirmation_instructions(
        adm,
        &Routes.adm_confirmation_url(conn, :confirm, &1)
      )
    end

    # Regardless of the outcome, show an impartial success/error message.
    conn
    |> put_flash(
      :info,
      "If your e-mail is in our system and it has not been confirmed yet, " <>
        "you will receive an e-mail with instructions shortly."
    )
    |> redirect(to: "/")
  end

  # Do not log in the adm after confirmation to avoid a
  # leaked token giving the adm access to the account.
  def confirm(conn, %{"token" => token}) do
    case Accounts.confirm_adm(token) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Account confirmed successfully.")
        |> redirect(to: "/")

      :error ->
        conn
        |> put_flash(:error, "Confirmation link is invalid or it has expired.")
        |> redirect(to: "/")
    end
  end
end

defmodule AppWeb.AdmSettingsController do
  use AppWeb, :controller

  alias App.Accounts
  alias AppWeb.AdmAuth

  plug :assign_email_and_password_changesets

  def edit(conn, _params) do
    render(conn, "edit.html")
  end

  def update_email(conn, %{"current_password" => password, "adm" => adm_params}) do
    adm = conn.assigns.current_adm

    case Accounts.apply_adm_email(adm, password, adm_params) do
      {:ok, applied_adm} ->
        Accounts.deliver_update_email_instructions(
          applied_adm,
          adm.email,
          &Routes.adm_settings_url(conn, :confirm_email, &1)
        )

        conn
        |> put_flash(
          :info,
          "A link to confirm your e-mail change has been sent to the new address."
        )
        |> redirect(to: Routes.adm_settings_path(conn, :edit))

      {:error, changeset} ->
        render(conn, "edit.html", email_changeset: changeset)
    end
  end

  def confirm_email(conn, %{"token" => token}) do
    case Accounts.update_adm_email(conn.assigns.current_adm, token) do
      :ok ->
        conn
        |> put_flash(:info, "E-mail changed successfully.")
        |> redirect(to: Routes.adm_settings_path(conn, :edit))

      :error ->
        conn
        |> put_flash(:error, "Email change link is invalid or it has expired.")
        |> redirect(to: Routes.adm_settings_path(conn, :edit))
    end
  end

  def update_password(conn, %{"current_password" => password, "adm" => adm_params}) do
    adm = conn.assigns.current_adm

    case Accounts.update_adm_password(adm, password, adm_params) do
      {:ok, adm} ->
        conn
        |> put_flash(:info, "Password updated successfully.")
        |> put_session(:adm_return_to, Routes.adm_settings_path(conn, :edit))
        |> AdmAuth.log_in_adm(adm)

      {:error, changeset} ->
        render(conn, "edit.html", password_changeset: changeset)
    end
  end

  defp assign_email_and_password_changesets(conn, _opts) do
    adm = conn.assigns.current_adm

    conn
    |> assign(:email_changeset, Accounts.change_adm_email(adm))
    |> assign(:password_changeset, Accounts.change_adm_password(adm))
  end
end

defmodule AppWeb.AdmRegistrationController do
  use AppWeb, :controller

  alias App.Accounts
  alias App.Accounts.Adm
  alias AppWeb.AdmAuth

  def new(conn, _params) do
    changeset = Accounts.change_adm_registration(%Adm{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"adm" => adm_params}) do
    case Accounts.register_adm(adm_params) do
      {:ok, adm} ->
        {:ok, _} =
          Accounts.deliver_adm_confirmation_instructions(
            adm,
            &Routes.adm_confirmation_url(conn, :confirm, &1)
          )

        conn
        |> put_flash(:info, "Adm created successfully.")
        |> AdmAuth.log_in_adm(adm)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end

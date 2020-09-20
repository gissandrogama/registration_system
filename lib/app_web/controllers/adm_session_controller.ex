defmodule AppWeb.AdmSessionController do
  use AppWeb, :controller

  alias App.Accounts
  alias AppWeb.AdmAuth

  def new(conn, _params) do
    render(conn, "new.html", error_message: nil)
  end

  def create(conn, %{"adm" => adm_params}) do
    %{"email" => email, "password" => password} = adm_params

    if adm = Accounts.get_adm_by_email_and_password(email, password) do
      AdmAuth.log_in_adm(conn, adm, adm_params)
    else
      render(conn, "new.html", error_message: "E-mail ou senha inválido.")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Desconectado com sucesso.")
    |> AdmAuth.log_out_adm()
  end
end

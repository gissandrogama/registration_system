defmodule App.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `App.Accounts` context.
  """

  def unique_name, do: "adm#{System.unique_integer()}"
  def unique_adm_email, do: "adm#{System.unique_integer()}@example.com"
  def valid_adm_password, do: "hello world!"

  def adm_fixture(attrs \\ %{}) do
    {:ok, adm} =
      attrs
      |> Enum.into(%{
        name: unique_name(),
        email: unique_adm_email(),
        password: valid_adm_password()
      })
      |> App.Accounts.register_adm()

    adm
  end

  def extract_adm_token(fun) do
    {:ok, captured} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token, _] = String.split(captured.body, "[TOKEN]")
    token
  end
end

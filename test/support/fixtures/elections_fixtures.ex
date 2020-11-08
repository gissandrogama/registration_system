defmodule App.ElectionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `App.ElectionsFixtures`.
  """

  import App.AccountsFixtures
  alias App.Elections

  # params to create leaders
  def leader_name, do: "some name"

  def leader_nascimento, do: "11/02/1991"

  def leader_bairro, do: "some bairro"

  def leader_cidade, do: "some cidade"

  def leader_titulo, do: Brcpfcnpj.cpf_generate()

  def leader_sessao, do: "some sessao"

  def leader_zona, do: "some zona"

  def leader_cpf, do: Brcpfcnpj.cpf_generate()

  def leader_rg, do: Brcpfcnpj.cpf_generate()

  def leader_endereco, do: "some endereco"

  def leader_telefone, do: "(91)98877-1150"

  def leader_nm_mae, do: "some mãe"

  def leader_cadsus, do: "some cadsus"

  def adm_by_id, do: adm_fixture()

  def leader_fixture(attrs \\ %{}) do
    {:ok, leader} =
      attrs
      |> Enum.into(%{
        name: leader_name(),
        nascimento: leader_nascimento(),
        bairro: leader_bairro(),
        cidade: leader_cidade(),
        titulo: leader_titulo(),
        sessao: leader_sessao(),
        zona: leader_zona(),
        cpf: leader_cpf(),
        rg: leader_rg(),
        endereco: leader_endereco(),
        telefone: leader_telefone(),
        nm_mae: leader_nm_mae(),
        cadsus: leader_cadsus(),
        adm_by_id: adm_fixture().id
      })
      |> Elections.create_leader()

    leader
  end

  # params to create voters
  def voter_name, do: "some name"

  def voter_nascimento, do: "05/09/1985"

  def voter_bairro, do: "some bairro"

  def voter_cidade, do: "some cidade"

  def voter_titulo, do: Brcpfcnpj.cpf_generate()

  def voter_sessao, do: "some sessao"

  def voter_zona, do: "some zona"

  def voter_cpf, do: Brcpfcnpj.cpf_generate()

  def voter_rg, do: Brcpfcnpj.cpf_generate()

  def voter_endereco, do: "some endereco"

  def voter_telefone, do: "(91)99955-2233"

  def voter_nm_mae, do: "some mãe"

  def voter_cadsus, do: "some cadsus"

  def leader_by_id, do: leader_fixture()

  def voter_fixture(attrs \\ %{}) do
    {:ok, voter} =
      attrs
      |> Enum.into(%{
        name: voter_name(),
        nascimento: voter_nascimento(),
        bairro: voter_bairro(),
        cidade: voter_cidade(),
        titulo: voter_titulo(),
        sessao: voter_sessao(),
        zona: voter_zona(),
        cpf: voter_cpf(),
        rg: voter_rg(),
        endereco: voter_endereco(),
        telefone: voter_telefone(),
        nm_mae: voter_nm_mae(),
        cadsus: voter_cadsus(),
        leader_by_id: leader_fixture().id
      })
      |> Elections.create_voter()

    voter
  end
end

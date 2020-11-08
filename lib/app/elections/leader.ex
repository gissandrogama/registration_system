defmodule App.Elections.Leader do
  @moduledoc """
  Schema of the leaders
  """
  use Ecto.Schema
  import Ecto.Changeset
  import Brcpfcnpj.Changeset

  alias App.Accounts.Adm

  schema "leaders" do
    field :name, :string
    field :nascimento, :string
    field :bairro, :string
    field :cadsus, :string
    field :titulo, :string
    field :sessao, :string
    field :cidade, :string
    field :cpf, :string
    field :endereco, :string
    field :nm_mae, :string
    field :rg, :string
    field :telefone, :string
    field :zona, :string
    belongs_to :adm_by, Adm

    timestamps()
  end

  @doc false
  def changeset(leader, attrs) do
    leader
    |> cast(attrs, [
      :name,
      :nascimento,
      :telefone,
      :endereco,
      :bairro,
      :cidade,
      :titulo,
      :zona,
      :sessao,
      :cpf,
      :rg,
      :cadsus,
      :nm_mae,
      :adm_by_id
    ])
    |> validate_required([
      :name,
      :titulo,
      :zona,
      :sessao,
      :adm_by_id
    ])
    |> validate_cpf(:cpf, message: "CPF inválido")
    |> unsafe_validate_unique(:cpf, App.Repo)
    |> unique_constraint(:cpf)
    |> unsafe_validate_unique(:rg, App.Repo)
    |> unique_constraint(:rg)
    |> unsafe_validate_unique(:titulo, App.Repo)
    |> unique_constraint(:titulo)
    |> foreign_key_constraint(:adm_by_id)
    |> validate_cell()
  end

  def validate_cell(changeset) do
    changeset
    |> validate_required([:telefone])
    |> validate_format(:telefone, ~r/\(\d{2}\)\d{5}-\d{4}/,
      message: "telefone inválido, formato correto (99)99999-9999"
    )
    |> validate_length(:telefone, max: 14, message: "telefone deve ter no máximo 14 caracteres")
  end
end

defmodule App.Elections.Voter do
  @moduledoc """
  Schema of the elections
  """
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]
  import Brcpfcnpj.Changeset

  alias App.Elections.Leader

  schema "voters" do
    field :bairro, :string
    field :cadsus, :string
    field :cidade, :string
    field :cpf, :string
    field :endereco, :string
    field :name, :string
    field :rg, :string
    field :sessao, :string
    field :telefone, :string
    field :zona, :string
    field :nm_mae, :string
    field :nascimento, :string
    field :titulo, :string
    belongs_to :leader_by, Leader

    timestamps()
  end

  @doc false
  def changeset(voter, attrs) do
    voter
    |> cast(attrs, [
      :name,
      :nascimento,
      :endereco,
      :bairro,
      :titulo,
      :sessao,
      :zona,
      :cidade,
      :cpf,
      :rg,
      :telefone,
      :cadsus,
      :nm_mae,
      :leader_by_id
    ])
    |> validate_required([
      :name,
      :titulo,
      :sessao,
      :zona,
      :leader_by_id
    ])
    |> validate_cpf(:cpf, message: "CPF inválido")
    |> unsafe_validate_unique(:cpf, App.Repo)
    |> unique_constraint(:cpf)
    |> unsafe_validate_unique(:rg, App.Repo)
    |> unique_constraint(:rg)
    |> unsafe_validate_unique(:titulo, App.Repo)
    |> unique_constraint(:titulo)
    |> foreign_key_constraint(:leader_by_id)
  end

  def search(query, search_term) do
    wilcard_search = "%#{search_term}%"

    from voter in query,
      where: ilike(voter.bairro, ^wilcard_search),
      or_where: ilike(voter.cidade, ^wilcard_search),
      or_where: ilike(voter.name, ^wilcard_search),
      or_where: voter.sessao == ^wilcard_search,
      or_where: voter.zona == ^wilcard_search
  end
end

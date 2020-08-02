defmodule App.Elections.Voter do
  use Ecto.Schema
  import Ecto.Changeset

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
    belongs_to :leader, Leader

    timestamps()
  end

  @doc false
  def changeset(voter, attrs) do
    voter
    |> cast(attrs, [:name, :endereco, :bairro, :sessao, :zona, :cidade, :cpf, :rg, :telefone, :cadsus, :leader_id])
    |> validate_required([:name, :endereco, :bairro, :sessao, :zona, :cidade, :cpf, :rg, :telefone, :cadsus, :leader_id])
    |> foreign_key_constraint(:leader_id)
  end
end

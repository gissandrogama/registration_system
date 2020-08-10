defmodule App.Elections.Leader do
  @moduledoc """
  Schema Leader 
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "name" do
    field :name, :string
    field :bairro, :string
    field :cadsus, :string
    field :cecao, :string
    field :cidade, :string
    field :cpf, :string
    field :endereco, :string
    field :nm_mae, :string
    field :rg, :string
    field :telefone, :string
    field :zona, :string

    timestamps()
  end

  @doc false
  def changeset(leader, attrs) do
    leader
    |> cast(attrs, [
      :name,
      :telefone,
      :endereco,
      :bairro,
      :cidade,
      :zona,
      :cecao,
      :cpf,
      :rg,
      :cadsus,
      :nm_mae
    ])
    |> validate_required([
      :name,
      :telefone,
      :endereco,
      :bairro,
      :cidade,
      :zona,
      :cecao,
      :cpf,
      :rg,
      :cadsus,
      :nm_mae
    ])
  end
end

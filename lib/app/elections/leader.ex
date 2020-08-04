defmodule App.Elections.Leader do
  @moduledoc """
  Schema of the leaders
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias App.Accounts.Adm

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
    belongs_to :adm_by, Adm

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
      :nm_mae,
      :adm_by_id
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
      :nm_mae,
      :adm_by_id
    ])
    |> foreign_key_constraint(:adm_by_id)
  end
end

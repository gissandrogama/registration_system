defmodule App.Repo.Migrations.CreateVoters do
  use Ecto.Migration

  def change do
    create table(:voters) do
      add :name, :string
      add :endereco, :string
      add :bairro, :string
      add :sessao, :string
      add :zona, :string
      add :cidade, :string
      add :cpf, :string
      add :rg, :string
      add :telefone, :string
      add :cadsus, :string
      add :leader_id, references(:name, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:voters, [:leader_id])
  end
end

defmodule App.Repo.Migrations.CreateLeaders do
  use Ecto.Migration

  def change do
    create table(:leaders) do
      add :name, :string
      add :telefone, :string
      add :endereco, :string
      add :bairro, :string
      add :cidade, :string
      add :zona, :string
      add :cecao, :string
      add :cpf, :string
      add :rg, :string
      add :cadsus, :string
      add :nm_mae, :string
      add :adm_by_id, references(:admins, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:leaders, [:adm_by_id])
  end
end

defmodule App.Repo.Migrations.CreateName do
  use Ecto.Migration

  def change do
    create table(:name) do
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
      add :adm_id, references(:admins, on_delete: :nothing), null: false

      timestamps()
    end
    create index(:name, [:adm_id])
  end
end

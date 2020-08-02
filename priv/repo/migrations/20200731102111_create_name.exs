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

      timestamps()
    end
  end
end

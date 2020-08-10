defmodule App.ElectionsTest do
  use App.DataCase

  alias App.Elections

  describe "name" do
    alias App.Elections.Leader

    @valid_attrs %{
      name: "some name",
      bairro: "some bairro",
      cadsus: "some cadsus",
      cecao: "some cecao",
      cidade: "some cidade",
      cpf: "some cpf",
      endereco: "some endereco",
      nm_mae: "some nm_mae",
      rg: "some rg",
      telefone: "some telefone",
      zona: "some zona"
    }
    @update_attrs %{
      name: "some updated name",
      bairro: "some updated bairro",
      cadsus: "some updated cadsus",
      cecao: "some updated cecao",
      cidade: "some updated cidade",
      cpf: "some updated cpf",
      endereco: "some updated endereco",
      nm_mae: "some updated nm_mae",
      rg: "some updated rg",
      telefone: "some updated telefone",
      zona: "some updated zona"
    }
    @invalid_attrs %{
      name: nil,
      bairro: nil,
      cadsus: nil,
      cecao: nil,
      cidade: nil,
      cpf: nil,
      endereco: nil,
      nm_mae: nil,
      rg: nil,
      telefone: nil,
      zona: nil
    }

    def leader_fixture(attrs \\ %{}) do
      {:ok, leader} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Elections.create_leader()

      leader
    end

    test "list_name/0 returns all name" do
      leader = leader_fixture()
      assert Elections.list_name() == [leader]
    end

    test "get_leader!/1 returns the leader with given id" do
      leader = leader_fixture()
      assert Elections.get_leader!(leader.id) == leader
    end

    test "create_leader/1 with valid data creates a leader" do
      assert {:ok, %Leader{} = leader} = Elections.create_leader(@valid_attrs)
      assert leader.name == "some name"
      assert leader.bairro == "some bairro"
      assert leader.cadsus == "some cadsus"
      assert leader.cecao == "some cecao"
      assert leader.cidade == "some cidade"
      assert leader.cpf == "some cpf"
      assert leader.endereco == "some endereco"
      assert leader.nm_mae == "some nm_mae"
      assert leader.rg == "some rg"
      assert leader.telefone == "some telefone"
      assert leader.zona == "some zona"
    end

    test "create_leader/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Elections.create_leader(@invalid_attrs)
    end

    test "update_leader/2 with valid data updates the leader" do
      leader = leader_fixture()
      assert {:ok, %Leader{} = leader} = Elections.update_leader(leader, @update_attrs)
      assert leader.name == "some updated name"
      assert leader.bairro == "some updated bairro"
      assert leader.cadsus == "some updated cadsus"
      assert leader.cecao == "some updated cecao"
      assert leader.cidade == "some updated cidade"
      assert leader.cpf == "some updated cpf"
      assert leader.endereco == "some updated endereco"
      assert leader.nm_mae == "some updated nm_mae"
      assert leader.rg == "some updated rg"
      assert leader.telefone == "some updated telefone"
      assert leader.zona == "some updated zona"
    end

    test "update_leader/2 with invalid data returns error changeset" do
      leader = leader_fixture()
      assert {:error, %Ecto.Changeset{}} = Elections.update_leader(leader, @invalid_attrs)
      assert leader == Elections.get_leader!(leader.id)
    end

    test "delete_leader/1 deletes the leader" do
      leader = leader_fixture()
      assert {:ok, %Leader{}} = Elections.delete_leader(leader)
      assert_raise Ecto.NoResultsError, fn -> Elections.get_leader!(leader.id) end
    end

    test "change_leader/1 returns a leader changeset" do
      leader = leader_fixture()
      assert %Ecto.Changeset{} = Elections.change_leader(leader)
    end
  end
end

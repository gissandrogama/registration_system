defmodule App.ElectionsTest do
  use App.DataCase

  import App.ElectionsFixtures
  import App.AccountsFixtures
  alias App.Elections
  alias App.Elections.{Leader, Voter}

  describe "leaders" do
    setup do
      %{leader: leader_fixture()}
    end

    setup do
      %{adm: adm_fixture()}
    end

    @update_attrs %{
      name: "some updated name",
      bairro: "some updated bairro",
      cadsus: "some updated cadsus",
      cecao: "some updated sessao",
      cidade: "some updated cidade",
      cpf: "30131772090",
      endereco: "some updated endereco",
      nm_mae: "some updated nm_mae",
      rg: "some updated rg",
      telefone: "some updated telefone",
      zona: "some updated zona"
    }
    @invalid_attrs %{
      bairro: nil,
      cadsus: nil,
      cecao: nil,
      cidade: nil,
      cpf: nil,
      endereco: nil,
      nm_mae: nil,
      rg: nil,
      telefone: nil,
      zona: nil,
      adm_by_id: nil
    }

    test "list_name/0 returns all leaders" do
      leader = leader_fixture()
      assert Elections.list_all_leader(leader.adm_by_id) == [leader]
    end

    test "get_leader!/1 returns the leader with given id" do
      leader = leader_fixture()
      assert Elections.get_leader!(leader.id) == leader
    end

    test "create_leader/1 with valid data creates a leader", %{adm: adm} do
      assert {:ok, %Leader{} = leader} =
               Elections.create_leader(%{
                 name: "some name",
                 nascimento: "02/09/1987",
                 bairro: "some bairro",
                 cadsus: "some cadsus",
                 titulo: "557584151392",
                 cecao: "some sessao",
                 cidade: "some cidade",
                 cpf: Brcpfcnpj.cpf_generate(),
                 endereco: "some endereco",
                 nm_mae: "some nm_mae",
                 rg: "some rg",
                 telefone: "some telefone",
                 zona: "some zona",
                 adm_by_id: adm.id
               })

      assert leader.name == "some name"
      assert leader.nascimento == "02/09/1987"
      assert leader.bairro == "some bairro"
      assert leader.cadsus == "some cadsus"
      assert leader.cecao == "some sessao"
      assert leader.cidade == "some cidade"
      assert leader.cpf == leader.cpf
      assert leader.endereco == "some endereco"
      assert leader.nm_mae == "some nm_mae"
      assert leader.rg == "some rg"
      assert leader.telefone == "some telefone"
      assert leader.titulo == "557584151392"
      assert leader.zona == "some zona"
      assert leader.adm_by_id == adm.id
    end

    test "create_leader/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Elections.create_leader(@invalid_attrs)
    end

    test "update_leader/2 with valid data updates the leader" do
      leader = leader_fixture()
      assert {:ok, %Leader{} = leader} = Elections.update_leader(leader, @update_attrs)
      assert leader.name == "some updated name"
      assert leader.nascimento == leader.nascimento
      assert leader.bairro == "some updated bairro"
      assert leader.cadsus == "some updated cadsus"
      assert leader.cecao == "some updated sessao"
      assert leader.cidade == "some updated cidade"
      assert leader.cpf == "30131772090"
      assert leader.endereco == "some updated endereco"
      assert leader.nm_mae == "some updated nm_mae"
      assert leader.rg == "some updated rg"
      assert leader.telefone == "some updated telefone"
      assert leader.zona == "some updated zona"
      assert leader.titulo == leader.titulo
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

  describe "voters" do
    setup do
      %{leader: leader_fixture()}
    end

    setup do
      %{voter: voter_fixture()}
    end

    @update_attrs %{
      bairro: "some updated bairro",
      cadsus: "some updated cadsus",
      cidade: "some updated cidade",
      cpf: "82021304094",
      endereco: "some updated endereco",
      name: "some updated name",
      rg: "some updated rg",
      sessao: "some updated sessao",
      telefone: "some updated telefone",
      zona: "some updated zona"
    }
    @invalid_attrs %{
      bairro: nil,
      cadsus: nil,
      cidade: nil,
      cpf: nil,
      endereco: nil,
      name: nil,
      rg: nil,
      sessao: nil,
      telefone: nil,
      zona: nil,
      leader_by_id: nil
    }

    test "list_voters/0 returns all voters" do
      voter = voter_fixture()
      assert Elections.list_all_voters(voter.leader_by_id) == [voter]
    end

    test "get_voter!/1 returns the voter with given id" do
      voter = voter_fixture()
      assert Elections.get_voter!(voter.id) == voter
    end

    test "create_voter/1 with valid data creates a voter", %{leader: leader} do
      assert {:ok, %Voter{} = voter} =
               Elections.create_voter(%{
                 name: "some name",
                 nascimento: "02/09/1987",
                 bairro: "some bairro",
                 cidade: "some cidade",
                 titulo: "302308481325",
                 sessao: "some sessao",
                 zona: "some zona",
                 cpf: Brcpfcnpj.cpf_generate(),
                 rg: "some rg",
                 endereco: "some endereço",
                 telefone: "some telefone",
                 nm_mae: "some mãe",
                 cadsus: "some cadsus",
                 leader_by_id: leader.id
               })

      assert voter.nascimento == "02/09/1987"
      assert voter.titulo == "302308481325"
      assert voter.bairro == "some bairro"
      assert voter.cadsus == "some cadsus"
      assert voter.cidade == "some cidade"
      assert voter.cpf == voter.cpf
      assert voter.endereco == "some endereço"
      assert voter.name == "some name"
      assert voter.rg == "some rg"
      assert voter.sessao == "some sessao"
      assert voter.telefone == "some telefone"
      assert voter.zona == "some zona"
      assert voter.leader_by_id == leader.id
    end

    test "create_voter/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Elections.create_voter(@invalid_attrs)
    end

    test "update_voter/2 with valid data updates the voter" do
      voter = voter_fixture()
      assert {:ok, %Voter{} = voter} = Elections.update_voter(voter, @update_attrs)
      assert voter.bairro == "some updated bairro"
      assert voter.cadsus == "some updated cadsus"
      assert voter.cidade == "some updated cidade"
      assert voter.cpf == "82021304094"
      assert voter.endereco == "some updated endereco"
      assert voter.name == "some updated name"
      assert voter.rg == "some updated rg"
      assert voter.sessao == "some updated sessao"
      assert voter.telefone == "some updated telefone"
      assert voter.zona == "some updated zona"
    end

    test "update_voter/2 with invalid data returns error changeset" do
      voter = voter_fixture()
      assert {:error, %Ecto.Changeset{}} = Elections.update_voter(voter, @invalid_attrs)
      assert voter == Elections.get_voter!(voter.id)
    end

    test "delete_voter/1 deletes the voter" do
      voter = voter_fixture()
      assert {:ok, %Voter{}} = Elections.delete_voter(voter)
      assert_raise Ecto.NoResultsError, fn -> Elections.get_voter!(voter.id) end
    end

    test "change_voter/1 returns a voter changeset" do
      voter = voter_fixture()
      assert %Ecto.Changeset{} = Elections.change_voter(voter)
    end
  end
end

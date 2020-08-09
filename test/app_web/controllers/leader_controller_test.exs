defmodule AppWeb.LeaderControllerTest do
  use AppWeb.ConnCase

  alias App.Elections

  @create_attrs %{
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

  def fixture(:leader) do
    {:ok, leader} = Elections.create_leader(@create_attrs)
    leader
  end

  describe "index" do
    test "lists all name", %{conn: conn} do
      conn = get(conn, Routes.leader_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Name"
    end
  end

  describe "new leader" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.leader_path(conn, :new))
      assert html_response(conn, 200) =~ "New Leader"
    end
  end

  describe "create leader" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.leader_path(conn, :create), leader: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.leader_path(conn, :show, id)

      conn = get(conn, Routes.leader_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Leader"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.leader_path(conn, :create), leader: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Leader"
    end
  end

  describe "edit leader" do
    setup [:create_leader]

    test "renders form for editing chosen leader", %{conn: conn, leader: leader} do
      conn = get(conn, Routes.leader_path(conn, :edit, leader))
      assert html_response(conn, 200) =~ "Edit Leader"
    end
  end

  describe "update leader" do
    setup [:create_leader]

    test "redirects when data is valid", %{conn: conn, leader: leader} do
      conn = put(conn, Routes.leader_path(conn, :update, leader), leader: @update_attrs)
      assert redirected_to(conn) == Routes.leader_path(conn, :show, leader)

      conn = get(conn, Routes.leader_path(conn, :show, leader))
      assert html_response(conn, 200) =~ "some updated bairro"
    end

    test "renders errors when data is invalid", %{conn: conn, leader: leader} do
      conn = put(conn, Routes.leader_path(conn, :update, leader), leader: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Leader"
    end
  end

  describe "delete leader" do
    setup [:create_leader]

    test "deletes chosen leader", %{conn: conn, leader: leader} do
      conn = delete(conn, Routes.leader_path(conn, :delete, leader))
      assert redirected_to(conn) == Routes.leader_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.leader_path(conn, :show, leader))
      end
    end
  end

  defp create_leader(_) do
    leader = fixture(:leader)
    %{leader: leader}
  end
end
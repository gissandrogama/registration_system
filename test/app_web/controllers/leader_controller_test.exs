defmodule AppWeb.LeaderControllerTest do
  use AppWeb.ConnCase

  import App.AccountsFixtures
  alias App.Elections

  setup :register_and_log_in_adm

  @create_attrs %{
    name: "some name",
    nascimento: "02/09/1985",
    bairro: "some bairro",
    cadsus: "some cadsus",
    titulo: "366678241384",
    cecao: "some cecao",
    cidade: "some cidade",
    cpf: Brcpfcnpj.cpf_generate(),
    endereco: "some endereco",
    nm_mae: "some nm_mae",
    rg: "some rg",
    telefone: "(91)98277-2244",
    zona: "some zona"
  }
  @update_attrs %{
    name: "some updated name",
    bairro: "some updated bairro",
    cadsus: "some updated cadsus",
    cecao: "some updated cecao",
    cidade: "some updated cidade",
    cpf: "61216339058",
    endereco: "some updated endereco",
    nm_mae: "some updated nm_mae",
    rg: "some updated rg",
    telefone: "(91)98277-2233",
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

  def fixture(:leader) do
    {:ok, leader} =
      Elections.create_leader(%{
        name: "some name",
        nascimento: "02/09/1987",
        bairro: "some bairro",
        cadsus: "some cadsus",
        titulo: "576145261325",
        cecao: "some cecao",
        cidade: "some cidade",
        cpf: Brcpfcnpj.cpf_generate(),
        endereco: "some endereco",
        nm_mae: "some nm_mae",
        rg: "some rg",
        telefone: "(91)98277-2211",
        zona: "some zona",
        adm_by_id: adm_fixture().id
      })

    leader
  end

  describe "index" do
    test "lists all name", %{conn: conn} do
      conn = get(conn, Routes.leader_path(conn, :index))

      assert html_response(conn, 200) =~
               "\n    <div class=\"align-middle inline-block min-w-full shadow overflow-hidden sm:rounded-lg border-b border-gray-200\">\n\n      <div class=\"flex justify-between\">\n        <h1 class=\"text-2xl font-semibold text-gray-800\">Lista de Líderes</h1>\n        <div class=\"flex justify-end items-center\">\n\n0\n\n\n          de 0\n\n\n        </div>\n      </div>\n\n      "
    end
  end

  describe "new leader" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.leader_path(conn, :new))

      assert html_response(conn, 200) =~
               "\n<h1 class=\"text-2xl text-center font-semibold text-gray-800\">Cadastar líder</h1>\n\n"
    end
  end

  describe "create leader" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.leader_path(conn, :create), leader: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.leader_path(conn, :show, id)

      conn = get(conn, Routes.leader_path(conn, :show, id))

      assert html_response(conn, 200) =~
               "\n  <p class=\"alert alert-info\" role=\"alert\">Líder criado com sucesso.</p>\n  "
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.leader_path(conn, :create), leader: @invalid_attrs)

      assert html_response(conn, 200) =~
               "\n<h1 class=\"text-2xl text-center font-semibold text-gray-800\">Cadastar líder</h1>\n\n"
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

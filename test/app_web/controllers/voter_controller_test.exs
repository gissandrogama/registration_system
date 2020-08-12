defmodule AppWeb.VoterControllerTest do
  use AppWeb.ConnCase

  import App.ElectionsFixtures
  alias App.Elections

  setup :register_and_log_in_adm

  @create_attrs %{
    name: "some name",
    endereco: "some endereco",
    bairro: "some bairro",
    sessao: "some sessao",
    zona: "some zona",
    cidade: "some cidade",
    cpf: "some cpf",
    rg: "some rg",
    telefone: "some telefone",
    cadsus: "some cadsus",
    nm_mae: "some mae"
  }
  @update_attrs %{
    name: "some updated name",
    endereco: "some updated endereco",
    bairro: "some updated bairro",
    sessao: "some updated sessao",
    zona: "some updated zona",
    cidade: "some updated cidade",
    cpf: "some updated cpf",
    rg: "some updated rg",
    telefone: "some updated telefone",
    cadsus: "some updated cadsus",
    nm_mae: "some updated mae"
  }
  @invalid_attrs %{
    name: nil,
    endereco: nil,
    bairro: nil,
    sessao: nil,
    zona: nil,
    cidade: nil,
    cpf: nil,
    rg: nil,
    telefone: nil,
    cadsus: nil,
    nm_mae: nil
  }

  def fixture(:voter) do
    {:ok, voter} =
      Elections.create_voter(%{
        name: "some name",
        endereco: "some endereco",
        bairro: "some bairro",
        sessao: "some sessao",
        zona: "some zona",
        cidade: "some cidade",
        cpf: "some cpf",
        rg: "some rg",
        telefone: "some telefone",
        cadsus: "some cadsus",
        nm_mae: "some mae",
        leader_by_id: leader_fixture().id
      })

    voter
  end

  describe "index" do
    test "lists all voters", %{conn: conn} do
      conn = get(conn, Routes.voter_path(conn, :index))

      assert html_response(conn, 200) =~
               "<h1 class=\"text-2xl font-semibold text-gray-800\">Lista de Eleitores</h1>\n\n"
    end
  end

  describe "new voter" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.voter_path(conn, :new))

      assert html_response(conn, 200) =~
               "\n<h1 class=\"text-2xl text-center font-semibold text-gray-800\">Cadastrar Eleitor</h1>\n\n"
    end
  end

  describe "create voter" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.voter_path(conn, :create), voter: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.voter_path(conn, :show, id)

      conn = get(conn, Routes.voter_path(conn, :show, id))

      assert html_response(conn, 200) =~
               " <div>\n    <nav class=\"bg-gray-800\">\n      <div class=\"max-w-7xl mx-auto px-4 sm:px-6 lg:px-8\">\n        <div class=\"flex items-center justify-between h-16\">\n          <div class=\"flex items-center\">\n            <div class=\"flex-shrink-0\">\n              <img class=\"h-8 w-8\" src=\"https://tailwindui.com//img/logos/workflow-mark-on-dark.svg\" alt=\"Workflow logo\" />\n              </div>\n              <div class=\"hidden md:block\">\n\n<div class=\"ml-10 flex items-baseline\">\n<a class=\"ml-4 px-3 py-2 rounded-md text-sm font-medium text-gray-300 hover:text-white hover:bg-gray-700 focus:outline-none focus:text-white focus:bg-gray-700\" href=\"/\">Início</a><a class=\"ml-4 px-3 py-2 rounded-md text-sm font-medium text-white bg-gray-900 focus:outline-none focus:text-white focus:bg-gray-700\" data-phx-link=\"patch\" data-phx-link-state=\"push\" href=\"/leader\">Líderes</a><a class=\"ml-4 px-3 py-2 rounded-md text-sm font-medium text-white bg-gray-900 focus:outline-none focus:text-white focus:bg-gray-700\" data-phx-link=\"patch\" data-phx-link-state=\"push\" href=\"/voter\">Eleitores</a></div>\n</div>\n</div>"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.voter_path(conn, :create), voter: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Voter"
    end
  end

  describe "edit voter" do
    setup [:create_voter]

    test "renders form for editing chosen voter", %{conn: conn, voter: voter} do
      conn = get(conn, Routes.voter_path(conn, :edit, voter))
      assert html_response(conn, 200) =~ "Edit Voter"
    end
  end

  describe "update voter" do
    setup [:create_voter]

    test "redirects when data is valid", %{conn: conn, voter: voter} do
      conn = put(conn, Routes.voter_path(conn, :update, voter), voter: @update_attrs)
      assert redirected_to(conn) == Routes.voter_path(conn, :show, voter)

      conn = get(conn, Routes.voter_path(conn, :show, voter))
      assert html_response(conn, 200) =~ "some updated bairro"
    end

    test "renders errors when data is invalid", %{conn: conn, voter: voter} do
      conn = put(conn, Routes.voter_path(conn, :update, voter), voter: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Voter"
    end
  end

  describe "delete voter" do
    setup [:create_voter]

    test "deletes chosen voter", %{conn: conn, voter: voter} do
      conn = delete(conn, Routes.voter_path(conn, :delete, voter))
      assert redirected_to(conn) == Routes.voter_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.voter_path(conn, :show, voter))
      end
    end
  end

  defp create_voter(_) do
    voter = fixture(:voter)
    %{voter: voter}
  end
end

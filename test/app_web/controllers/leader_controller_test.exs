defmodule AppWeb.LeaderControllerTest do
  use AppWeb.ConnCase

  import App.AccountsFixtures
  alias App.Elections

  setup :register_and_log_in_adm

  @create_attrs %{
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

  def fixture(:leader) do
    {:ok, leader} =
      Elections.create_leader(%{
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
        zona: "some zona",
        adm_by_id: adm_fixture().id
      })

    leader
  end

  describe "index" do
    test "lists all name", %{conn: conn} do
      conn = get(conn, Routes.leader_path(conn, :index))
      assert html_response(conn, 200) =~ " <div>\n    <nav class=\"bg-gray-800\">\n      <div class=\"max-w-7xl mx-auto px-4 sm:px-6 lg:px-8\">\n        <div class=\"flex items-center justify-between h-16\">\n          <div class=\"flex items-center\">\n            <div class=\"flex-shrink-0\">\n              <img class=\"h-8 w-8\" src=\"https://tailwindui.com//img/logos/workflow-mark-on-dark.svg\" alt=\"Workflow logo\" />\n              </div>\n              <div class=\"hidden md:block\">\n\n<div class=\"ml-10 flex items-baseline\">\n<a class=\"ml-4 px-3 py-2 rounded-md text-sm font-medium text-gray-300 hover:text-white hover:bg-gray-700 focus:outline-none focus:text-white focus:bg-gray-700\" href=\"/\">Início</a><a class=\"ml-4 px-3 py-2 rounded-md text-sm font-medium text-white bg-gray-900 focus:outline-none focus:text-white focus:bg-gray-700\" data-phx-link=\"patch\" data-phx-link-state=\"push\" href=\"/leader\">Líderes</a><a class=\"ml-4 px-3 py-2 rounded-md text-sm font-medium text-white bg-gray-900 focus:outline-none focus:text-white focus:bg-gray-700\" data-phx-link=\"patch\" data-phx-link-state=\"push\" href=\"/voter\">Eleitores</a></div>\n</div>\n</div>"
    end
  end

  describe "new leader" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.leader_path(conn, :new))
      assert html_response(conn, 200) =~ " <div>\n    <nav class=\"bg-gray-800\">\n      <div class=\"max-w-7xl mx-auto px-4 sm:px-6 lg:px-8\">\n        <div class=\"flex items-center justify-between h-16\">\n          <div class=\"flex items-center\">\n            <div class=\"flex-shrink-0\">\n              <img class=\"h-8 w-8\" src=\"https://tailwindui.com//img/logos/workflow-mark-on-dark.svg\" alt=\"Workflow logo\" />\n              </div>\n              <div class=\"hidden md:block\">\n\n<div class=\"ml-10 flex items-baseline\">\n<a class=\"ml-4 px-3 py-2 rounded-md text-sm font-medium text-gray-300 hover:text-white hover:bg-gray-700 focus:outline-none focus:text-white focus:bg-gray-700\" href=\"/\">Início</a><a class=\"ml-4 px-3 py-2 rounded-md text-sm font-medium text-white bg-gray-900 focus:outline-none focus:text-white focus:bg-gray-700\" data-phx-link=\"patch\" data-phx-link-state=\"push\" href=\"/leader\">Líderes</a><a class=\"ml-4 px-3 py-2 rounded-md text-sm font-medium text-white bg-gray-900 focus:outline-none focus:text-white focus:bg-gray-700\" data-phx-link=\"patch\" data-phx-link-state=\"push\" href=\"/voter\">Eleitores</a></div>\n</div>\n</div>"
    end
  end

  describe "create leader" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.leader_path(conn, :create), leader: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.leader_path(conn, :show, id)

      conn = get(conn, Routes.leader_path(conn, :show, id))
      assert html_response(conn, 200) =~ " <div>\n    <nav class=\"bg-gray-800\">\n      <div class=\"max-w-7xl mx-auto px-4 sm:px-6 lg:px-8\">\n        <div class=\"flex items-center justify-between h-16\">\n          <div class=\"flex items-center\">\n            <div class=\"flex-shrink-0\">\n              <img class=\"h-8 w-8\" src=\"https://tailwindui.com//img/logos/workflow-mark-on-dark.svg\" alt=\"Workflow logo\" />\n              </div>\n              <div class=\"hidden md:block\">\n\n<div class=\"ml-10 flex items-baseline\">\n<a class=\"ml-4 px-3 py-2 rounded-md text-sm font-medium text-gray-300 hover:text-white hover:bg-gray-700 focus:outline-none focus:text-white focus:bg-gray-700\" href=\"/\">Início</a><a class=\"ml-4 px-3 py-2 rounded-md text-sm font-medium text-white bg-gray-900 focus:outline-none focus:text-white focus:bg-gray-700\" data-phx-link=\"patch\" data-phx-link-state=\"push\" href=\"/leader\">Líderes</a><a class=\"ml-4 px-3 py-2 rounded-md text-sm font-medium text-white bg-gray-900 focus:outline-none focus:text-white focus:bg-gray-700\" data-phx-link=\"patch\" data-phx-link-state=\"push\" href=\"/voter\">Eleitores</a></div>\n</div>\n</div>"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.leader_path(conn, :create), leader: @invalid_attrs)
      assert html_response(conn, 200) =~ " <div>\n    <nav class=\"bg-gray-800\">\n      <div class=\"max-w-7xl mx-auto px-4 sm:px-6 lg:px-8\">\n        <div class=\"flex items-center justify-between h-16\">\n          <div class=\"flex items-center\">\n            <div class=\"flex-shrink-0\">\n              <img class=\"h-8 w-8\" src=\"https://tailwindui.com//img/logos/workflow-mark-on-dark.svg\" alt=\"Workflow logo\" />\n              </div>\n              <div class=\"hidden md:block\">\n\n<div class=\"ml-10 flex items-baseline\">\n<a class=\"ml-4 px-3 py-2 rounded-md text-sm font-medium text-gray-300 hover:text-white hover:bg-gray-700 focus:outline-none focus:text-white focus:bg-gray-700\" href=\"/\">Início</a><a class=\"ml-4 px-3 py-2 rounded-md text-sm font-medium text-white bg-gray-900 focus:outline-none focus:text-white focus:bg-gray-700\" data-phx-link=\"patch\" data-phx-link-state=\"push\" href=\"/leader\">Líderes</a><a class=\"ml-4 px-3 py-2 rounded-md text-sm font-medium text-white bg-gray-900 focus:outline-none focus:text-white focus:bg-gray-700\" data-phx-link=\"patch\" data-phx-link-state=\"push\" href=\"/voter\">Eleitores</a></div>\n</div>\n</div>"
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

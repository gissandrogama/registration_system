defmodule AppWeb.VoterControllerTest do
  use AppWeb.ConnCase

  alias App.Elections

  @create_attrs %{
    bairro: "some bairro",
    cadsus: "some cadsus",
    cidade: "some cidade",
    cpf: "some cpf",
    endereco: "some endereco",
    name: "some name",
    rg: "some rg",
    sessao: "some sessao",
    telefone: "some telefone",
    zona: "some zona"
  }
  @update_attrs %{
    bairro: "some updated bairro",
    cadsus: "some updated cadsus",
    cidade: "some updated cidade",
    cpf: "some updated cpf",
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
    zona: nil
  }

  def fixture(:voter) do
    {:ok, voter} = Elections.create_voter(@create_attrs)
    voter
  end

  describe "index" do
    test "lists all voters", %{conn: conn} do
      conn = get(conn, Routes.voter_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Voters"
    end
  end

  describe "new voter" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.voter_path(conn, :new))
      assert html_response(conn, 200) =~ "New Voter"
    end
  end

  describe "create voter" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.voter_path(conn, :create), voter: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.voter_path(conn, :show, id)

      conn = get(conn, Routes.voter_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Voter"
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

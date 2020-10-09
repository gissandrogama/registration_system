defmodule AppWeb.VoterControllerTest do
  use AppWeb.ConnCase

  import App.ElectionsFixtures
  alias App.Elections

  setup :register_and_log_in_adm

  @update_attrs %{
    name: "some updated name",
    nascimento: "02/09/1987",
    endereco: "some updated endereco",
    bairro: "some updated bairro",
    titulo: "388212351376",
    sessao: "some updated sessao",
    zona: "some updated zona",
    cidade: "some updated cidade",
    cpf: "49134063021",
    rg: "some updated rg",
    telefone: "some updated telefone",
    cadsus: "some updated cadsus",
    nm_mae: "some updated mae",
    leader_by_id: "some name"
  }
  @invalid_attrs %{
    name: nil,
    nascimento: nil,
    endereco: nil,
    bairro: nil,
    titulo: nil,
    sessao: nil,
    zona: nil,
    cidade: nil,
    cpf: nil,
    rg: nil,
    telefone: nil,
    cadsus: nil,
    nm_mae: nil,
    leader_by_id: "some name"
  }

  def fixture(:voter) do
    {:ok, voter} =
      Elections.create_voter(%{
        name: "some name",
        nascimento: "02/09/1987",
        endereco: "some endereco",
        bairro: "some bairro",
        titulo: "236253431333",
        sessao: "some sessao",
        zona: "some zona",
        cidade: "some cidade",
        cpf: Brcpfcnpj.cpf_generate(),
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
               "</div>\n</form>  <div class=\"flex flex-col\">\n    <div class=\"-my-2 py-2 overflow-x-auto sm:-mx-6 sm:px-6 lg:-mx-8 lg:px-8\">\n      <div class=\"align-middle inline-block min-w-full shadow overflow-hidden sm:rounded-lg border-b border-gray-200\">\n        <div class=\"flex justify-between\">\n      <h1 class=\"text-2xl font-semibold text-gray-800\">Lista de Eleitores</h1>\n      <div class=\"flex justify-end items-center\">\n        1 -\n\n0\n        de 0\n\n        <div class=\"hover:text-gray-800 text-gray-600 font-bold py-2 px-4 rounded inline-flex items-center\">\n          <svg class=\"w-6 h-6\" xmlns=\"http://www.w3.org/2000/svg\" fill=\"none\" viewBox=\"0 0 24 24\" stroke=\"currentColor\">\n            <path stroke-linecap=\"round\" stroke-linejoin=\"round\" stroke-width=\"2\" d=\"M15 19l-7-7 7-7\" />\n          </svg>\n<a class=\"w-6 h-6\" href=\"/voter?page=0\">Prev</a>        </div>\n\n        <div class=\"hover:text-gray-800 text-gray-600 font-bold py-2 px-4 rounded inline-flex items-center\">\n<a class=\"mr-3 w-6 h-6\" href=\"/voter?page=2\">Next</a>          <svg class=\"w-6 h-6\" xmlns=\"http://www.w3.org/2000/svg\" fill=\"none\" viewBox=\"0 0 24 24\" stroke=\"currentColor\">\n            <path stroke-linecap=\"round\" stroke-linejoin=\"round\" stroke-width=\"2\" d=\"M9 5l7 7-7 7\" />\n          </svg>\n        </div>\n      </div>\n    </div>\n\n        "
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
    setup do
      %{leaders: leader_fixture()}
    end

    test "redirects to show when data is valid", %{conn: conn, leaders: leaders} do
      conn =
        post(conn, Routes.voter_path(conn, :create),
          voter: %{
            name: "some name",
            nascimento: "02/09/1987",
            endereco: "some endereco",
            bairro: "some bairro",
            titulo: "388212351376",
            sessao: "some sessao",
            zona: "some zona",
            cidade: "some cidade",
            cpf: Brcpfcnpj.cpf_generate(),
            rg: "some rg",
            telefone: "some telefone",
            cadsus: "some cadsus",
            nm_mae: "some mae",
            leader_by_id: leaders.id
          }
        )

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.voter_path(conn, :show, id)

      conn = get(conn, Routes.voter_path(conn, :show, id))

      assert html_response(conn, 200) =~
               "\n  <p class=\"alert alert-info\" role=\"alert\">Eleitor criado com sucesso.</p>\n  "
    end
  end

  describe "edit voter" do
    setup [:create_voter]

    test "renders form for editing chosen voter", %{conn: conn, voter: voter} do
      conn = get(conn, Routes.voter_path(conn, :edit, voter))

      assert html_response(conn, 200) =~
               "\n<h1 class=\"text-2xl text-center font-semibold text-gray-800\">Editar Eleitor</h1>\n\n"
    end
  end

  describe "update voter" do
    setup [:create_voter]

    test "redirects when data is valid", %{conn: conn, voter: voter} do
      conn = put(conn, Routes.voter_path(conn, :update, voter), voter: @update_attrs)
      assert redirected_to(conn) == Routes.voter_path(conn, :show, voter)

      conn = get(conn, Routes.voter_path(conn, :show, voter))

      assert html_response(conn, 200) =~ "02/09/1987"
    end

    test "renders errors when data is invalid", %{conn: conn, voter: voter} do
      conn = put(conn, Routes.voter_path(conn, :update, voter), voter: @invalid_attrs)

      assert html_response(conn, 200) =~
               "\n<h1 class=\"text-2xl text-center font-semibold text-gray-800\">Editar Eleitor</h1>\n\n"
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

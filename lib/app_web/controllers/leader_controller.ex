defmodule AppWeb.LeaderController do
  use AppWeb, :controller

  alias App.Elections
  alias App.Elections.Leader
  alias App.Repo

  def index(conn, params) do
    # leaders = Elections.list_leaders()
    page =
      Leader
      |> App.Repo.paginate(params)

    render(conn, "index.html", leaders: page.entries, page: page)
  end

  def new(conn, _params) do
    changeset = Elections.change_leader(%Leader{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"leader" => leader_params}) do
    adm = conn.assigns.current_adm
    leader_params = Map.put(leader_params, "adm_by_id", adm.id)

    case Elections.create_leader(leader_params) do
      {:ok, leader} ->
        conn
        |> put_flash(:info, "Líder criado com sucesso.")
        |> redirect(to: Routes.leader_path(conn, :show, leader))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    leader = Elections.get_leader!(id)
    render(conn, "show.html", leader: leader)
  end

  def edit(conn, %{"id" => id}) do
    leader = Elections.get_leader!(id)
    changeset = Elections.change_leader(leader)
    render(conn, "edit.html", leader: leader, changeset: changeset)
  end

  def update(conn, %{"id" => id, "leader" => leader_params}) do
    leader = Elections.get_leader!(id)

    case Elections.update_leader(leader, leader_params) do
      {:ok, leader} ->
        conn
        |> put_flash(:info, "Líder atualizado com sucesso.")
        |> redirect(to: Routes.leader_path(conn, :show, leader))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", leader: leader, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    leader = Elections.get_leader!(id)
    {:ok, _leader} = Elections.delete_leader(leader)

    conn
    |> put_flash(:info, "Líder excluído com sucesso.")
    |> redirect(to: Routes.leader_path(conn, :index))
  end

  def export(conn, _params) do
    value = List.keyfind(conn.req_headers, "referer", 0)
    list = Tuple.to_list(value)
    a = List.delete_at(list, 0)
    string = to_string(a)
    table = String.replace_prefix(string, "http://localhost:4000/", "")

    conn =
      conn
      |> put_resp_content_type("text/csv")
      |> put_resp_header(
        "content-disposition",
        ~s[attachment; filename="lideres_#{Elections.date_now()}.csv"]
      )
      |> send_chunked(:ok)

    {:ok, conn} =
      Repo.transaction(fn ->
        Elections.export_data_csv(table)
        |> Enum.reduce_while(conn, fn data, conn ->
          case chunk(conn, data) do
            {:ok, conn} ->
              {:cont, conn}

            {:error, :closed} ->
              {:halt, conn}
          end
        end)
      end)

    conn
  end
end

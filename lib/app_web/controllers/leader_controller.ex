defmodule AppWeb.LeaderController do
  use AppWeb, :controller

  alias App.Elections
  alias App.Elections.Leader

  def index(conn, _params) do
    leaders = Elections.list_leaders()
    render(conn, "index.html", leaders: leaders)
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
        |> put_flash(:info, "Leader created successfully.")
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
        |> put_flash(:info, "Leader updated successfully.")
        |> redirect(to: Routes.leader_path(conn, :show, leader))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", leader: leader, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    leader = Elections.get_leader!(id)
    {:ok, _leader} = Elections.delete_leader(leader)

    conn
    |> put_flash(:info, "Leader deleted successfully.")
    |> redirect(to: Routes.leader_path(conn, :index))
  end
end

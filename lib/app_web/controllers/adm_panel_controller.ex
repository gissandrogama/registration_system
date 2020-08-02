defmodule AppWeb.AdmPanelController do
  use AppWeb, :controller

  def new(conn, _params) do
    render(conn, "new.html")
  end
end

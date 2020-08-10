defmodule AppWeb.PageLive do
  @moduledoc """
  function taht mount socket
  """
  use AppWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end

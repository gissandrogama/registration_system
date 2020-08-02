defmodule AppWeb.TeamLive do
  @moduledoc false
  use AppWeb, :live_view
  alias AppWeb.ModalComponent

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       team_members: leaders(),
       reconnected: get_connect_params(socket)["_mounts"] > 0,
       base_page_loaded: false,
       member_to_delete: nil
     )}
  end

  @impl Phoenix.LiveView
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @spec apply_action(Socket.t(), atom(), map()) :: Socket.t()
  def apply_action(socket, :index, _params) do
    assign(socket, member_to_delete: nil, base_page_loaded: true)
  end

  def apply_action(socket, :delete_member, %{"id" => user_id}) do
    member =
      get_member(
        socket.assigns.team_members,
        String.to_integer(user_id)
      )

    if member && okay_to_show_modal?(socket) do
      assign(socket, member_to_delete: member)
    else
      push_patch_index(socket)
    end
  end

  @impl Phoenix.LiveView
  def handle_event("delete-member", %{"user-id" => user_id}, socket) do
    {:noreply, push_patch_delete_member_modal(socket, String.to_integer(user_id))}
  end

  # Handle message to self() from Remove Member confirmation modal ok button
  def handle_info(
        {ModalComponent, :button_pressed, %{action: "delete-member"}},
        %{assigns: %{member_to_delete: member_to_delete, team_members: team_members}} = socket
      ) do
    team_members = delete_member(team_members, member_to_delete.user_id)

    {:noreply,
     socket
     |> assign(team_members: team_members)}
  end

  # Handle message to self() from Remove User confirmation modal cancel button
  def handle_info(
        {ModalComponent, :button_pressed, %{action: "cancel-delete-member", param: _}},
        socket
      ) do
    {:noreply, socket}
  end

  # Modal closed message
  @impl Phoenix.LiveView
  def handle_info(
        {ModalComponent, :modal_closed, %{id: "confirm-delete-member"}},
        socket
      ) do
    {:noreply, push_patch_index(socket)}
  end

  defp okay_to_show_modal?(socket) do
    %{assigns: %{base_page_loaded: base_page_loaded, reconnected: reconnected}} = socket

    !connected?(socket) || base_page_loaded || reconnected
  end

  defp push_patch_index(socket) do
    push_patch(
      socket,
      to: Routes.team_path(socket, :index),
      replace: true
    )
  end

  defp push_patch_delete_member_modal(socket, user_id) do
    push_patch(
      socket,
      to: Routes.team_path(socket, :delete_member, user_id),
      replace: true
    )
  end

  defp get_member(team_members, user_id) do
    Enum.find(team_members, fn member -> member.user_id == user_id end)
  end

  defp delete_member(team_members, user_id) do
    Enum.reject(team_members, fn member -> member.user_id == user_id end)
  end

  defp leaders do
    [
      %{
        user_id: 1,
        avatar: "https://pbs.twimg.com/profile_images/1211815447793950720/J9Wp8LsD_400x400.jpg",
        name: "Raphael Gama",
        email: "raphaelgama@example.com",
        position: "Director",
        department: "Web Developer",
        status: "Active",
        role: "Owner"
      },
      %{
        user_id: 2,
        avatar: "https://pbs.twimg.com/profile_images/1116058175441121280/UBoaJFXY_400x400.png",
        name: "Gissandro Gama",
        email: "gissandrogama@example.com",
        position: "Director",
        department: "Web Designer",
        status: "Active",
        role: "Owner"
      },
      %{
        user_id: 3,
        avatar: "https://pbs.twimg.com/profile_images/1261681328686338049/QyXVbPmS_400x400.jpg",
        name: "Frank Ferreira",
        email: "frankferreira@example.com",
        position: "Director",
        department: "Web Developer",
        status: "Active",
        role: "Owner"
      }
    ]
  end
end

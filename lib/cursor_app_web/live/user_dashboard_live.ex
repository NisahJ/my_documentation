defmodule CursorAppWeb.UserDashboardLive do
  use CursorAppWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page_title, "User Dashboard")}
  end
end

defmodule CursorAppWeb.Live.AdminDashboardLive do
  use CursorAppWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page_title, "Admin Dashboard")}
  end

  def mount(_params, _session, socket) do
    {:ok, socket, layout: {CursorAppWeb.Layouts, :admin_layout}}
  end

end

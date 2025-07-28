defmodule CursorAppWeb.AdminUsersLive do
  use CursorAppWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1 class="text-2xl font-bold mb-4">Manage Users</h1>
    <p>Senarai pengguna akan ditampilkan di sini.</p>
    """
  end
end

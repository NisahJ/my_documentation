defmodule CursorAppWeb.UserDashboardLive do
  use CursorAppWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page_title, "User Dashboard")}
  end

  def render(assigns) do
    ~H"""
      <div class="flex justify-center items-center">
        <div class="text-center">
          <h1 class="text-3xl font-bold mb-6 text-zinc-800">Admin Dashboard</h1>
          <p class="text-lg text-zinc-600 font-medium">Selamat datang ke dashboard admin!</p>
        </div>
      </div>
     """
end
end

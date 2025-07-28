defmodule CursorAppWeb.AdminUsersLive do
  use CursorAppWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-screen pt-20 px-4 relative">
    <!-- Butang Back Fixed -->
    <div class="fixed top-4 left-4 md:left-6 md:top-6 z-50 w-full flex md:justify-start">
      <.link
        navigate={~p"/admin"}
        class="inline-block bg-blue-600 hover:bg-indigo-700 text-white font-semibold px-4 py-2 rounded shadow"
      >
        ← Back to Dashboard
      </.link>
    </div>

    <!-- Kotak content center -->
    <div class="max-w-xl mx-auto mt-6 bg-white/90 p-6 rounded-lg shadow-md">
      <h1 class="text-2xl font-bold mb-4 text-zinc-800">Manage Users</h1>
      <p class="text-base font-medium text-zinc-700">
        Senarai pengguna akan ditampilkan di sini.
      </p>
    </div>
    </div>
    """
  end
end

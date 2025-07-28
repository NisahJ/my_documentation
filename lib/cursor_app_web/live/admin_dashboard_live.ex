defmodule CursorAppWeb.Live.AdminDashboardLive do
  use CursorAppWeb, :live_view

   # Assign default state (sidebar terbuka)
   def mount(_params, _session, socket) do
    {:ok, assign(socket, :sidebar_open, true)}
  end

  # Tangani klik burger button
  def handle_event("toggle_sidebar", _params, socket) do
    {:noreply, update(socket, :sidebar_open, fn open -> not open end)}
  end

   # Paparan (guna @sidebar_open)
   def render(assigns) do
    ~H"""
    <div class="">
      <!-- Sidebar -->
      <aside class={[
        "transition-all duration-300 ease-in-out",
        @sidebar_open && "w-55 bg-zinc-800 text-white p-8 shadow-md rounded-r-lg",
        !@sidebar_open && "w-0 overflow-hidden"
      ]}>
        <%= if @sidebar_open do %>
          <h2 class="text-xl font-bold mb-6">Admin Menu</h2>
          <nav class="space-y-2">
            <.link navigate={~p"/admin/settings"} class="block px-4 py-2 rounded hover:bg-zinc-700">⚙️ Settings</.link>
            <.link navigate={~p"/admin/users"} class="block px-4 py-2 rounded hover:bg-zinc-700">👥 Users</.link>
          </nav>
        <% end %>
      </aside>

      <!-- Main Content -->
      <main class="flex-1 bg-gray-100 p-6">
        <button
          phx-click="toggle_sidebar"
          class="mb-4 bg-zinc-800 text-white p-2 rounded"
        >
          ☰
        </button>

        <h1 class="text-3xl font-bold mb-6">Admin Dashboard</h1>
        <p>Selamat datang ke dashboard admin!</p>
      </main>
    </div>
    """
  end
  end

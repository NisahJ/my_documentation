defmodule CursorAppWeb.Live.AdminDashboardLive do
  use CursorAppWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       sidebar_open: true,
       page: "dashboard",
       show_users_sub: false
     )}
  end

  def handle_event("toggle_sidebar", _params, socket) do
    {:noreply, update(socket, :sidebar_open, fn open -> not open end)}
  end

  def handle_event("toggle_users_sub", _params, socket) do
    {:noreply, update(socket, :show_users_sub, fn val -> not val end)}
  end

  def handle_params(%{"list" => "1"}, _url, socket) do
    users = CursorApp.Accounts.list_users()

    {:noreply,
     socket
     |> assign(:page, "list_1")
     |> assign(:users, users)}
  end

  def handle_params(%{"list" => id}, _url, socket) do
    {:noreply, assign(socket, page: "list_#{id}")}
  end

  def handle_params(_, _url, socket) do
    {:noreply, assign(socket, page: "dashboard")}
  end

  def render(assigns) do
    ~H"""
    <div class="flex min-h-screen bg-white/70">
      <!-- Sidebar -->
      <aside class={[
        "transition-all duration-300 ease-in-out",
        @sidebar_open && "w-64 bg-zinc-700 text-white p-6 shadow-md rounded-l-lg rounded-r-lg",
        !@sidebar_open && "w-0 overflow-hidden"
      ]}>
        <%= if @sidebar_open do %>
          <h2 class="text-xl font-bold mb-6">Admin Menu</h2>
          <nav class="space-y-2">
            <.link navigate={~p"/admin/settings"} class="block px-4 py-2 rounded hover:bg-zinc-700">
              ⚙️ Settings
            </.link>

            <!-- Users Section -->
            <div>
              <button phx-click="toggle_users_sub"
                      class="w-full text-left font-semibold px-4 py-2 hover:bg-zinc-700 flex items-center justify-between">
                <span>👥 Users</span>
                <span><%= if @show_users_sub, do: "▲", else: "▼" %></span>
              </button>

              <ul :if={@show_users_sub} class="pl-6 space-y-1 text-sm text-white">
                <li><.link patch={~p"/admin/users/list/1"} class="hover:underline">Senarai 1</.link></li>
                <li><.link patch={~p"/admin/users/list/2"} class="hover:underline">Senarai 2</.link></li>
                <li><.link patch={~p"/admin/users/list/3"} class="hover:underline">Senarai 3</.link></li>
              </ul>
            </div>
          </nav>
        <% end %>
      </aside>

      <!-- Main Content -->
      <main class="flex-1 p-6">
        <!-- Toggle Sidebar Button -->
        <button phx-click="toggle_sidebar"
                class="mb-4 bg-zinc-800 text-white p-2 rounded">
          ☰
        </button>

        <!-- Page Content -->
        <%= case @page do %>
  <% "dashboard" -> %>
    <div class="text-center">
      <h1 class="text-3xl font-bold mb-6">Admin Dashboard</h1>
      <p>Selamat datang ke dashboard admin!</p>
    </div>

  <% "list_1" -> %>
    <div class="max-w-4xl mx-left mt-8">
      <h2 class="text-2xl font-bold mb-4 text-zinc-800">Senarai Email Pengguna</h2>
      <div class="overflow-auto rounded shadow">
        <table class="w-full text-left text-sm bg-white/80 backdrop-blur-sm border border-zinc-300">
          <thead class="bg-zinc-200 text-zinc-800">
            <tr>
              <th class="px-4 py-2">#</th>
              <th class="px-4 py-2">Email</th>
            </tr>
          </thead>
          <tbody>
            <%= for {user, index} <- Enum.with_index(@users || [], 1) do %>
              <tr class="border-b hover:bg-zinc-50">
                <td class="px-4 py-2"><%= index %></td>
                <td class="px-4 py-2"><%= user.email %></td>
              </tr>
            <% end %>
          </tbody>
        </table>
      </div>
    </div>

  <% "list_2" -> %>
    <div class="max-w-4xl mx-left">
      <h1 class="text-2xl font-bold mb-4 text-zinc-800">Senarai 2 – Projek Aktif</h1>
      <p class="mb-4 font-semibold text-zinc-600">Senarai projek yang sedang berjalan...</p>
      <div class="grid grid-cols-2 gap-4">
        <div class="bg-white p-4 rounded shadow">
          <h3 class="font-semibold text-zinc-800">Projek A</h3>
          <p class="text-sm text-zinc-600">Status: Berjalan</p>
        </div>
        <div class="bg-white p-4 rounded shadow">
          <h3 class="font-semibold text-zinc-800">Projek B</h3>
          <p class="text-sm text-zinc-600">Status: Perancangan</p>
        </div>
      </div>
    </div>

  <% "list_3" -> %>
    <div class="max-w-4xl mx-left">
      <h1 class="text-2xl font-bold mb-4 text-zinc-800">Senarai 3 – Laporan</h1>
      <p class="mb-4 font-semibold text-zinc-600">Laporan prestasi atau penggunaan sistem.</p>
      <ul class="list-disc pl-6 space-y-2 text-black-700">
        <li>Laporan log masuk pengguna</li>
        <li>Laporan aktiviti mingguan</li>
        <li>Laporan sistem error</li>
      </ul>
    </div>

  <% _ -> %>
    <div class="text-red-500">Page tidak dijumpai: <%= @page %></div>
<% end %>

      </main>
    </div>
    """
  end
end

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
            <div class="max-w-5xl mx-auto">
              <h1 class="text-2xl font-bold mb-6 text-zinc-800">Senarai 1 – Pengguna</h1>

              <%= if flash = @flash[:info] do %>
                <div class="mb-4 bg-green-100 text-green-800 px-4 py-2 rounded">
                  <%= flash %>
                </div>
              <% end %>

              <div class="overflow-auto rounded shadow mb-8">
                <table class="w-full text-left text-sm bg-white/80 backdrop-blur-sm">
                  <thead class="bg-zinc-200 text-zinc-800">
                    <tr>
                      <th class="px-4 py-2">Nama</th>
                      <th class="px-4 py-2">Umur</th>
                      <th class="px-4 py-2">Alamat</th>
                      <th class="px-4 py-2">Email</th>
                    </tr>
                  </thead>
                  <tbody>
                    <%= for user <- @users do %>
                      <tr class="border-b hover:bg-zinc-50">
                        <td class="px-4 py-2"><%= user.name %></td>
                        <td class="px-4 py-2"><%= user.age %></td>
                        <td class="px-4 py-2"><%= user.address %></td>
                        <td class="px-4 py-2"><%= user.email %></td>
                      </tr>
                    <% end %>
                  </tbody>
                </table>
              </div>

              <div class="bg-white/80 backdrop-blur-sm p-6 rounded shadow">
                <h2 class="text-lg font-semibold mb-4 text-zinc-800">Tambah Pengguna Baru</h2>

                <.form for={@changeset} phx-submit="save_user" class="space-y-4">
                  <div>
                    <label class="block text-sm">Nama</label>
                    <.input type="text" name="user[name]" value={@changeset.data.name} />
                  </div>

                  <div>
                    <label class="block text-sm">Email</label>
                    <.input type="email" name="user[email]" value={@changeset.data.email} />
                  </div>

                  <div>
                    <label class="block text-sm">Umur</label>
                    <.input type="number" name="user[age]" value={@changeset.data.age} />
                  </div>

                  <div>
                    <label class="block text-sm">Alamat</label>
                    <.input type="text" name="user[address]" value={@changeset.data.address} />
                  </div>

                  <div>
                    <label class="block text-sm">Password</label>
                    <.input type="password" name="user[password]" />
                  </div>

                  <.button class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">
                    Tambah
                  </.button>
                </.form>
              </div>
            </div>

          <% "list_2" -> %>
            <div class="text-center">
              <h1 class="text-2xl font-bold mb-4 text-zinc-800">Senarai 2</h1>
              <p class="text-zinc-600">Ini adalah kandungan Senarai 2.</p>
            </div>

          <% "list_3" -> %>
            <div class="text-center">
              <h1 class="text-2xl font-bold mb-4 text-zinc-800">Senarai 3</h1>
              <p class="text-zinc-600">Ini adalah kandungan Senarai 3.</p>
            </div>
        <% end %>
      </main>
    </div>
    """
  end
end

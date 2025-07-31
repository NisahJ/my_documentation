defmodule CursorAppWeb.Live.AdminDashboardLive do
  use CursorAppWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       sidebar_open: true,
       page: "dashboard",
       show_users_sub: false,
       selected_user_id: nil,
       users_section_active: false,
       show_status_dropdown: false
     )}
  end


  def handle_event("toggle_sidebar", _params, socket) do   ## ini untuk side bar
    {:noreply, update(socket, :sidebar_open, fn open -> not open end)}
  end

  def handle_event("toggle_users_sub", _params, socket) do  ## ini untuk sub_unit (sub_user dalam side bar)
    {:noreply, update(socket, :show_users_sub, fn val -> not val end)}
  end

  def handle_event("toggle_status_dropdown", _params, socket) do
    {:noreply, update(socket, :show_status_dropdown, fn val -> not val end)}
  end

  def handle_event("search", %{"q" => query}, socket) do
    role = socket.assigns.selected_role || ""
    {:noreply,
     push_patch(socket,
       to: ~p"/admin/users/list/1?role=#{role}&q=#{URI.encode(query)}&page=1"
     )}
  end

  def handle_event("filter_role", %{"role" => role}, socket) do
    {:noreply,
     push_patch(socket,
       to: ~p"/admin/users/list/1?role=#{role}&page=1"
     )}
  end

  def handle_event("select_user", %{"id" => id}, socket) do
    {:noreply, assign(socket, :selected_user_id, id)}
  end

  def handle_event("edit_user", %{"id" => id}, socket) do
    # Contoh: redirect ke borang edit (atau boleh buat popup)
    {:noreply, put_flash(socket, :info, "Edit user ID: #{id}")}
  end

  def handle_event("delete_user", %{"id" => id}, socket) do
    user = String.to_integer(id)
    {:ok, _} = CursorApp.Accounts.delete_user(user)

    users = CursorApp.Accounts.list_users()

    {:noreply,
     socket
     |> assign(:users, users)
     |> put_flash(:info, "Pengguna dipadam")}
  end

  def handle_params(%{"list" => "1"} = params, _url, socket) do
    page_int = String.to_integer(Map.get(params, "page", "1"))
    role = Map.get(params, "role", nil)
    query = Map.get(params, "q", "") # default kosong jika tiada
    per_page = 5
    offset = (page_int - 1) * per_page

    filters = %{
      limit: per_page,
      offset: offset,
      role: role,
      query: query
    }

    users = CursorApp.Accounts.list_users(filters)
    total_users = CursorApp.Accounts.count_users(filters)
    total_pages = div(total_users + per_page - 1, per_page)

    {:noreply,
     socket
     |> assign(:page, "list_1")
     |> assign(:users, users)
     |> assign(:pagination, %{page: page_int, total_pages: total_pages})
     |> assign(:selected_role, role)
     |> assign(:search_query, query)
     |> assign(:users_section_active, true)}
  end

  def handle_params(%{"list" => id}, _url, socket) do     ## ini untuk list_2 (senarai_2) dan list_3 (senarai_3), dan list-list yang lain
    {:noreply, assign(socket, page: "list_#{id}")}
  end

  def handle_params(_, _url, socket) do
    {:noreply,
     socket
     |> assign(:page, "dashboard")
     |> assign(:users_section_active, false)}  # ← penting
  end


  def render(assigns) do
    ~H"""
    <div class="flex min-h-screen bg-white/70 rounded-lg">
      <!-- Sidebar -->
      <aside class={[
        "transition-all duration-300 ease-in-out",
        @sidebar_open && "w-64 bg-zinc-700 text-white p-6 shadow-md rounded-l-lg rounded-r-lg",
        !@sidebar_open && "w-0 overflow-hidden"
      ]}>
        <%= if @sidebar_open do %>
          <h2 class="text-xl font-bold mb-6">Admin Menu</h2>
          <nav class="space-y-2">

          <.link patch={"/admin"}class={["block px-4 py-2 rounded",
              @page == "dashboard" && "bg-zinc-600 text-white font-bold" || "hover:bg-zinc-700"]}>
              🏠 Admin Homepage
          </.link>

            <!-- Users Section -->
            <div>
              <button
                     phx-click="toggle_users_sub"
                     class={["w-full text-left font-semibold px-4 py-2 flex items-center justify-between rounded",
                             @users_section_active && "bg-zinc-600 text-white" || "hover:bg-zinc-700"]}>
                     <span>👥 Users</span>
                     <span><%= if @show_users_sub, do: "▲", else: "▼" %></span>
              </button>

              <ul :if={@show_users_sub} class="pl-6 space-y-1 text-sm text-white">
                  <%= for i <- 1..3 do %>
               <li>
               <.link
                     patch={"/admin/users/list/#{i}"}
                     class={["block px-2 py-1 rounded transition-colors",
                     @page == "list_#{i}" && "bg-zinc-600 font-bold" || "hover:bg-zinc-600"]}>
                     Senarai <%= i %>
               </.link>
               </li>
               <% end %>
              </ul>
            </div>

           <.link navigate={~p"/admin/settings"} class="block px-4 py-2 rounded hover:bg-zinc-700">
              ⚙️ Settings
            </.link>

          </nav>
        <% end %>
      </aside>

      <!-- Main Content -->
      <main class="flex-1 p-6 ">
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
    <h2 class="text-2xl font-bold mb-4 text-zinc-800">Senarai 1 – Email Pengguna</h2>

    <!-- ✅ Status Dropdown + Search Bar dalam satu baris -->
     <div class="flex flex-wrap items-center justify-between gap-4 mb-4">
       <!-- Status Dropdown -->
     <div class="relative inline-block text-left">
       <button
            type="button"
            phx-click="toggle_status_dropdown"
            class="inline-flex justify-center rounded-md border border-gray-300 shadow-sm px-4 py-2 bg-white text-sm font-medium text-gray-700 hover:bg-gray-50"
       >
            Status <%= if @selected_role, do: "(#{String.capitalize(@selected_role)})" %> ▼
       </button>

     <div :if={@show_status_dropdown} class="absolute mt-2 w-40 rounded-md shadow-lg bg-white ring-1 ring-black ring-opacity-5 z-10">
      <div class="py-1 text-sm text-gray-700">
        <.link patch={"/admin/users/list/1?role=&page=1&q=#{@search_query}"} class="block px-4 py-2 hover:bg-gray-100">Semua</.link>
        <.link patch={"/admin/users/list/1?role=admin&page=1&q=#{@search_query}"} class="block px-4 py-2 hover:bg-gray-100">Admin</.link>
        <.link patch={"/admin/users/list/1?role=user&page=1&q=#{@search_query}"} class="block px-4 py-2 hover:bg-gray-100">User</.link>
        </div>
       </div>
      </div>

         <!-- Search Bar -->
     <form phx-change="search" phx-submit="search">
        <input
          type="text"
          name="q"
          value={@search_query}
          placeholder="Search email or status..."
          class="border border-gray-300 rounded px-3 py-2 w-64"
        />
       </form>
      </div>
     </div>

    <div class="overflow-auto rounded shadow">
    <table class="w-full text-left text-sm bg-white/80 backdrop-blur-sm border border-zinc-300">
      <thead class="bg-zinc-200 text-zinc-800">
        <tr>
          <th class="px-4 py-2">Bil</th>
          <th class="px-4 py-2">Email</th>
          <th class="px-4 py-2">Status</th>
          <th class="px-4 py-2">Tindakan</th>
        </tr>
      </thead>
      <tbody>
        <%= for {user, index} <- Enum.with_index(@users || [], (@pagination.page - 1) * 5 + 1) do %>
          <tr class="border-b hover:bg-yellow-50">
            <td class="px-4 py-2"><%= index %></td>
            <td class="px-4 py-2"><%= user.email %></td>

            <td class="px-4 py-2">
        <%= case user.role do %>
            <% "admin" -> %>
          <span class="inline-block px-2 py-1 bg-red-100 text-red-800 rounded text-xs font-semibold">Admin</span>
            <% "user" -> %>
          <span class="inline-block px-2 py-1 bg-blue-100 text-blue-800 rounded text-xs font-semibold">User</span>
            <% _ -> %>
          <span class="text-gray-500">Tidak diketahui</span>
        <% end %>
        </td>

            <td class="px-4 py-2 space-x-2">
              <button phx-click="edit_user" phx-value-id={user.id} class="text-blue-600 hover:underline">Edit</button>
              <button phx-click="delete_user" phx-value-id={user.id} class="text-red-600 hover:underline">Delete</button>
            </td>
          </tr>
        <% end %>
      </tbody>
     </table>
    </div>

     <!-- ✅ PAGINATION -->

       <!-- list_1 -->
      <div class="flex justify-left mt-6 space-x-2">
          <%= for p <- 1..@pagination.total_pages do %>
               <.link
                patch={"/admin/users/list/1?page=#{p}&q=#{@search_query}&role=#{@selected_role}"}
                class={["px-3 py-1 rounded border",
                       if p == @pagination.page do
                       "bg-blue-600 text-white border-blue-600"
                        else
                       "bg-white text-blue-600 hover:bg-blue-100 border-gray-300"
                       end
                       ]}>
               <%= p %>
             </.link>
           <% end %>
       </div>

    <!-- list_2 -->
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
    </div>S

    <!-- list_3 --S>
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

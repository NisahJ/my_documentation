defmodule CursorAppWeb.Live.AdminDashboardLive do
  use CursorAppWeb, :live_view

  @spec mount(any(), any(), map()) :: {:ok, map()}
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page_title, "Admin Dashboard")}
  end

  def render(assigns) do
    ~H"""
    <h1 class="text-3xl font-bold mb-6">Admin Dashboard</h1>
    <div>

      <nav class="h-full overflow-y-auto p-4">
       <ul class="space-y-2">

        <li>
          <a href={~p"/admin/settings"} class="block p-2 rounded hover:bg-gray-700"> Setting </a>
        </li>

        <li>
          <a href={~p"/admin/users"} class="block p-2 rounded hover:bg-gray-700"> User </a>
        </li>

        </ul>
      </nav>
    </div>
    """
  end
  end

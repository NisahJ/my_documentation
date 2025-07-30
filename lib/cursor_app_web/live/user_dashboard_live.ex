defmodule CursorAppWeb.UserDashboardLive do
  use CursorAppWeb, :live_view

  def mount(_params, _session, socket) do
    IO.inspect(socket.assigns.current_user, label: "✅ current_user dalam LiveView")

    {:ok, assign(socket, page_title: "User Dashboard")}
  end

  def render(assigns) do
    ~H"""
    <main class="min-h flex items-center justify-center">
      <div class="bg-zinc-30 shadow-lg rounded p-8 max-w-md w-full text-center">
        <h1 class="text-3xl font-bold text-blue-700 mb-4">Selamat Datang!</h1>

        <%= if @current_user do %>
          <p class="text-lg text-zinc-800">
            👋 Hai, <strong><%= @current_user.email %></strong>
          </p>
        <% else %>
          <p class="text-red-500">Tiada pengguna log masuk.</p>
        <% end %>

        <p class="text-sm text-zinc-600 mt-2">Ini adalah halaman dashboard pengguna.</p>
      </div>
    </main>
    """
  end
end

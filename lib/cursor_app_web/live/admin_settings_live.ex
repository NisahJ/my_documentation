defmodule CursorAppWeb.AdminSettingsLive do
  use CursorAppWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
  <div class="max-w-xl mx-auto mt-10 bg-white/90 p-6 rounded-lg shadow-md">
    <h1 class="text-2xl font-bold mb-4 text-zinc-800">System Settings</h1>
    <p class="text-base font-medium text-zinc-700">Konfigurasi sistem berada di sini.</p>
  </div>
  """
  end
end

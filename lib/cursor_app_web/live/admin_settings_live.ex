defmodule CursorAppWeb.AdminSettingsLive do
  use CursorAppWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1 class="text-2xl font-bold mb-4">System Settings</h1>
    <p>Konfigurasi sistem berada di sini.</p>
    """
  end
end

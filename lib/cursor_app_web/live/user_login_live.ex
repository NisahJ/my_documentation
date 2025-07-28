defmodule CursorAppWeb.UserLoginLive do
  use CursorAppWeb, :live_view

  def render(assigns) do
   ~H"""
<div class="flex items-center justify-center min-h-screen">
  <div class="bg-white/90 p-8 rounded-xl shadow-lg w-full max-w-md">
    <.header class="text-center mb-6">
      Log in to your account
      <:subtitle>
        Don't have an account?
        <.link navigate={~p"/users/register"} class="font-semibold text-indigo-600 hover:underline">
          Sign up
        </.link>
        now.
      </:subtitle>
    </.header>

    <.simple_form for={@form} id="login_form" action={~p"/users/log_in"} phx-update="ignore">
      <.input field={@form[:email]} type="email" label="Email" required />
      <.input field={@form[:password]} type="password" label="Password" required />

      <:actions>
        <div class="flex items-center justify-between">
          <.input field={@form[:remember_me]} type="checkbox" label="Keep me logged in" />
          <.link href={~p"/users/reset_password"} class="text-sm font-semibold text-indigo-600 hover:underline">
            Forgot password?
          </.link>
        </div>
      </:actions>

      <:actions>
        <.button phx-disable-with="Logging in..." class="w-full bg-indigo-600 hover:bg-indigo-700 text-white">
          Log in <span aria-hidden="true">→</span>
        </.button>
      </:actions>
    </.simple_form>
  </div>
</div>
"""
end

  def mount(_params, _session, socket) do
    email = Phoenix.Flash.get(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end

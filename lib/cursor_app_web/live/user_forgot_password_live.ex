defmodule CursorAppWeb.UserForgotPasswordLive do
  use CursorAppWeb, :live_view

  alias CursorApp.Accounts

  def render(assigns) do
    ~H"""
<div class="flex items-center justify-center min-h-screen">
  <div class="bg-white/90 p-8 rounded-xl shadow-lg w-full max-w-md">
    <.header class="text-center mb-6">
      Forgot your password?
      <:subtitle>We’ll send a password reset link to your inbox.</:subtitle>
    </.header>

    <.simple_form for={@form} id="reset_password_form" phx-submit="send_email">
      <.input field={@form[:email]} type="email" placeholder="Email" label="Email" required />

      <:actions>
        <.button phx-disable-with="Sending..." class="w-full bg-indigo-600 hover:bg-indigo-700 text-white">
          Send password reset instructions
        </.button>
      </:actions>
    </.simple_form>

    <div class="mt-6 text-center text-sm">
      <.link navigate={~p"/users/register"} class="text-indigo-600 font-medium hover:underline">
        Register
      </.link>
      <span class="mx-2 text-gray-400">|</span>
      <.link navigate={~p"/users/log_in"} class="text-indigo-600 font-medium hover:underline">
        Log in
      </.link>
    </div>
  </div>
</div>
"""
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(%{}, as: "user"))}
  end

  def handle_event("send_email", %{"user" => %{"email" => email}}, socket) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_reset_password_instructions(
        user,
        &url(~p"/users/reset_password/#{&1}")
      )
    end

    info =
      "If your email is in our system, you will receive instructions to reset your password shortly."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> redirect(to: ~p"/")}
  end
end

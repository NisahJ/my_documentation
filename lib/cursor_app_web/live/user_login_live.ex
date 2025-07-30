defmodule CursorAppWeb.UserLoginLive do
  use CursorAppWeb, :live_view

  alias CursorApp.Accounts
  alias CursorAppWeb.UserAuth

  def mount(_params, _session, socket) do
    form = to_form(%{"email" => "", "password" => ""}, as: "user")
    {:ok, assign(socket, form: form)}
  end

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

        <.simple_form for={@form} id="login_form" phx-submit="login">
          <.input field={@form[:email]} type="email" label="Email" required />
          <.input field={@form[:password]} type="password" label="Password" required />

          <:actions>
            <.button phx-disable-with="Logging in..." class="w-full">Log in</.button>
          </:actions>
        </.simple_form>

        <p class="text-sm mt-4 text-center">
          Don't have an account?
          <.link navigate={~p"/users/register"} class="text-indigo-600 font-semibold">Register</.link>
        </p>
      </div>
    </div>
    """
  end

  def handle_event("login", %{"user" => %{"email" => email, "password" => password}}, socket) do
    case CursorApp.Accounts.get_user_by_email_and_password(email, password) do
      %CursorApp.Accounts.User{} = user ->

        IO.inspect(user, label: "👤 User object")
        IO.inspect(route_after_login(user), label: "🌍 Going to")

        {:noreply,
         push_navigate(socket,
           to: ~p"/users/live_redirect?email=#{user.email}&goto=#{route_after_login(user)}"
         )}

      nil ->
        form = to_form(%{"email" => email}, as: "user")

        {:noreply,
         socket
         |> put_flash(:error, "Invalid email or password")
         |> assign(form: form)}
    end
  end

  defp route_after_login(%{role: "admin"}), do: "/admin"
  defp route_after_login(%{role: "user"}), do: "/user"
  defp route_after_login(_), do: "/"
end

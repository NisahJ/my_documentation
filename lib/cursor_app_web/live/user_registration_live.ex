defmodule CursorAppWeb.UserRegistrationLive do
  use CursorAppWeb, :live_view

  alias CursorApp.Accounts
  alias CursorApp.Accounts.User

  # HEEx Template
  def render(assigns) do
    ~H"""
    <div class="flex items-center justify-center min-h-screen">
      <div class="bg-white/90 p-8 rounded-xl shadow-lg w-full max-w-md">
        <.header class="text-center mb-6">
          Register for an account
          <:subtitle>
            Already have an account?
            <.link navigate={~p"/users/log_in"} class="font-semibold text-indigo-600 hover:underline">
              Log in
            </.link>
            to your account now.
          </:subtitle>
        </.header>

        <.simple_form
          for={@form}
          id="registration_form"
          phx-submit="save"
          phx-change="validate"
          phx-trigger-action={@trigger_submit}
          action={~p"/users/log_in?_action=registered"}
          method="post"
        >
          <.error :if={@check_errors}>
            <div class="mb-4 text-sm text-red-600 font-medium">
              Oops, something went wrong! Please check the errors below.
            </div>
          </.error>

          <.input field={@form[:email]} type="email" label="Email" required />
          <.input field={@form[:password]} type="password" label="Password" required />

          <:actions>
            <.button phx-disable-with="Creating account..." class="w-full bg-indigo-600 hover:bg-indigo-700 text-white">
              Create an account
            </.button>
          </:actions>
        </.simple_form>
      </div>
    </div>
    """
  end

  # Mount assigns
  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{})

    {:ok,
     socket
     |> assign(:changeset, changeset)
     |> assign(:form, to_form(changeset, as: "user"))
     |> assign(:trigger_submit, false)
     |> assign(:role, "user") # ⚠️ "admin" ditimpa, jadi kekalkan satu sahaja
     |> assign(:check_errors, false)}
  end

  # Validate event (digabungkan dan dikemas)
  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset =
      %User{}
      |> Accounts.change_user_registration(user_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  # Save event
  def handle_event("save", %{"user" => user_params}, socket) do
    user_params = Map.put(user_params, "role", socket.assigns.role)

    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &url(~p"/users/confirm/#{&1}")
          )

        {:noreply,
         socket
         |> put_flash(:info, "User created successfully.")
         |> assign(:trigger_submit, true)}

      {:error, changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  # Helper untuk assign form
  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    socket
    |> assign(:changeset, changeset)
    |> assign(:form, form)
    |> assign(:check_errors, not changeset.valid?)
  end
end

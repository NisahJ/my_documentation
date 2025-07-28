defmodule CursorAppWeb.UserRegistrationLive do
  use CursorAppWeb, :live_view

  alias CursorApp.Accounts
  alias CursorApp.Accounts.User

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

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{})

    {:ok,
     socket
     |> assign(:changeset, changeset)
     |> assign(:form, to_form(changeset))
     |> assign(:trigger_submit, false)
     |> assign(:role, "admin")
     |> assign(:role, "user")
     |> assign(:check_errors, false)}
  end


 def handle_event("validate", %{"user" => user_params}, socket) do
  changeset =
    %User{}
    |> Accounts.change_user_registration(user_params)
    |> Map.put(:action, :validate)

    {:noreply,
    socket
    |> assign(:changeset, changeset)
    |> assign(:form, to_form(changeset))
    |> assign(:check_errors, true)}
    # 🟢 wajib
end


  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_registration(%User{}, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end

    def handle_event("save", %{"user" => user_params} = _params, socket) do
      user_params = Map.put(user_params, "role", socket.assigns.role)

      case Accounts.register_user(user_params) do
        {:ok, user} ->
          {:ok, _} = Accounts.deliver_user_confirmation_instructions(
            user,
            &url(~p"/users/confirm/#{&1}")
          )

          {:noreply,
           socket
           |> put_flash(:info, "User created successfully.")
           |> assign(:trigger_submit, true)}

        {:error, changeset} ->
          {:noreply,
           socket
           |> assign(:changeset, changeset)
           |> assign(:form, to_form(changeset))
           |> assign(:check_errors, true)}
      end
    end
  end

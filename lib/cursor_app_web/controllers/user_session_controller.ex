defmodule CursorAppWeb.UserSessionController do
  use CursorAppWeb, :controller

  alias CursorApp.Accounts
  alias CursorAppWeb.UserAuth


  def from_live(conn, %{"email" => email, "goto" => goto}) do
    IO.inspect(goto, label: "➡️ Redirect path")

    case CursorApp.Accounts.get_user_by_email(email) do
      %CursorApp.Accounts.User{} = user ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> CursorAppWeb.UserAuth.log_in_user(user, goto)

      _ ->
        conn
        |> put_flash(:error, "Login session error.")
        |> redirect(to: ~p"/")
    end
  end

  def create(conn, %{"user" => user_params}) do
    create(conn, %{"user" => user_params}, "Welcome back!")
  end

  def create(conn, %{"_action" => "registered"} = params) do
    create(conn, params, "Account created successfully!")
  end

  def create(conn, %{"_action" => "password_updated"} = params) do
    conn
    |> put_session(:user_return_to, ~p"/users/settings")
    |> create(params, "Password updated successfully!")
  end

  defp create(conn, %{"user" => user_params}, info) do
    %{"email" => email, "password" => password} = user_params

    if user = Accounts.get_user_by_email_and_password(email, password) do
      conn
      |> put_flash(:info, info)
      |> UserAuth.log_in_user(user, user_params)
    else
      # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
      conn
      |> put_flash(:error, "Invalid email or password")
      |> put_flash(:email, String.slice(email, 0, 160))
      |> redirect(to: ~p"/users/log_in")
    end
  end
  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end
end

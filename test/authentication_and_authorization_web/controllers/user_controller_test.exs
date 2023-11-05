defmodule AuthenticationAndAuthorizationWeb.UserControllerTest do
  use AuthenticationAndAuthorizationWeb.ConnCase

  alias AuthenticationAndAuthorization.Repo
  alias AuthenticationAndAuthorization.Accounts.User

  describe "sign_up/1" do

    @valid_user %{
      user: %{
        first_name: "John",
        last_name: "Doe",
        email: "johnDoe@example.com",
        username: "JohnDoe123",
        password: "validPassword1!"
      }
    }

    test "successful sign up, responds with :created", %{conn: conn} do
      # Checks if user does not exist in data base
      assert Repo.aggregate(User, :count, :id) == 0

      conn = post(conn, "/sign-up", @valid_user)

      assert json_response(conn, 201)["message"] == "User created successfully"

      assert Repo.aggregate(User, :count, :id) == 1
    end

    test "unsuccessful sign-up, email already taken, responds with :unprocessable_entity", %{conn: conn} do
      # Creates user.
      conn_after_post = post(conn, "/sign-up", @valid_user)

      # Check if the first user was created successfully
      assert json_response(conn_after_post, 201)["message"] == "User created successfully"

      # Check the user count to ensure a user has been created.
      assert Repo.aggregate(User, :count, :id) == 1

      # Attempts to create user with same email.
      failed_request = post(conn, "/sign-up", @valid_user)

      # Check the response for the error message.
      assert json_response(failed_request, 422) == %{
        "errors" => %{
          "email" => ["has already been taken"]
        }
      }

      # Ensure that no additional user records were created.
      assert Repo.aggregate(User, :count, :id) == 1
    end

    test "unsuccessful sign-up, username already taken, responds with :unprocessable_entity", %{conn: conn} do
      conn_after_post = post(conn, "/sign-up", @valid_user)

      assert json_response(conn_after_post, 201)["message"] == "User created successfully"

      assert Repo.aggregate(User, :count, :id) == 1

      invalid_entity = %{
        user: %{
          first_name: "John",
          last_name: "Doe",
          email: "johnDoe1@example.com",
          username: "JohnDoe123",
          password: "validPassword1!"
        }
      }

      assert Repo.aggregate(User, :count, :id) == 1

      failed_request = post(conn, "/sign-up", invalid_entity)

      assert json_response(failed_request, 422) == %{
        "errors" => %{
          "username" => ["has already been taken"]
        }
      }

      assert Repo.aggregate(User, :count, :id) == 1
    end

    @invalid_user %{
      user: %{
        email: "johnDoe@example.com",
        username: "JohnDoe123",
        password: "validPassword1!"
      }
    }

    test "unsuccessful sign-up, first_name and last_name not provided, responds with :unprocessable_entity", %{conn: conn} do
      conn_post = post(conn, "/sign-up", @invalid_user)

      assert json_response(conn_post, 422) == %{
        "errors" => %{
          "first_name" => ["can't be blank"],
          "last_name" => ["can't be blank"]
        }
      }

      assert Repo.aggregate(User, :count, :id) == 0
    end

    @blank_email_user %{
      user: %{
        first_name: "John",
        last_name: "Doe",
        email: "",
        username: "JohnDoe123",
        password: "validPassword1!"
      }
    }

    test "unsuccessful sign-up, email not provided, responds with :unprocessable_entity", %{conn: conn} do
      conn_post = post(conn, "/sign-up", @blank_email_user)

      assert json_response(conn_post, 422) == %{
        "errors" => %{
          "email" => ["can't be blank"]
        }
      }

      assert Repo.aggregate(User, :count, :id) == 0
    end
  end

  @blank_username_user %{
    user: %{
      first_name: "John",
      last_name: "Doe",
      email: "johnDoe@example.com",
      username: "",
      password: "validPassword1!"
    }
  }

  test "unsuccessful sign-up, username not provided, responds with :unprocessable_entity", %{conn: conn} do
    conn_post = post(conn, "/sign-up", @blank_username_user)

    assert json_response(conn_post, 422) == %{
      "errors" => %{
        "username" => ["can't be blank"]
      }
    }

    assert Repo.aggregate(User, :count, :id) == 0
  end

  @blank_password_user %{
    user: %{
      first_name: "John",
      last_name: "Doe",
      email: "johnDoe@example.com",
      username: "JohnDoe123",
      password: ""
    }
  }

  test "unsuccessful sign-up, password not provided, responds with :unprocessable_entity", %{conn: conn} do
    conn_post = post(conn, "/sign-up", @blank_password_user)

    assert json_response(conn_post, 422) == %{
      "errors" => %{
        "password" => ["can't be blank"]
      }
    }

    assert Repo.aggregate(User, :count, :id) == 0
  end

  @invalid_email_format_user %{
    user: %{
      first_name: "John",
      last_name: "Doe",
      email: "invalidemail",
      username: "JohnDoe123",
      password: "validPassword1!"
    }
  }

  test "unsuccessful sign-up, invalid email format, responds with :unprocessable_entity", %{conn: conn} do
    conn_post = post(conn, "/sign-up", @invalid_email_format_user)

    assert json_response(conn_post, 422) == %{
      "errors" => %{
        "email" => ["is not a valid email address"]
      }
    }

    assert Repo.aggregate(User, :count, :id) == 0
  end

  @invalid_password_format_user %{
    user: %{
      first_name: "John",
      last_name: "Doe",
      email: "johnDoe@example.com",
      username: "JohnDoe123",
      password: "invalidpass"
    }
  }

  test "unsuccessful sign-up, invalid password format, responds with :unprocessable_entity", %{conn: conn} do
    conn_post = post(conn, "/sign-up", @invalid_password_format_user)

    assert json_response(conn_post, 422) == %{
      "errors" => %{
        "password" => ["must include at least one uppercase letter, one lowercase letter, one number, and one special character"]
      }
    }

    assert Repo.aggregate(User, :count, :id) == 0
  end

  describe "sign-in/2" do

    @username_sign_in %{
      user: %{
        username: "JohnDoe123",
        password: "validPassword1!"
      }
    }

    test "successful sign-in with username, responds with :ok", %{conn: conn} do
      post(conn, "/sign-up", @valid_user)

      assert Repo.aggregate(User, :count, :id) == 1

      sign_in_post = post(conn, "/sign-in", @username_sign_in)

      assert json_response(sign_in_post, 200)["message"] == "Signed in successfully."
    end

    @email_sign_in %{
      user: %{
        email: "johnDoe@example.com",
        password: "validPassword1!"
      }
    }

    test "successful sign-in with email, responds with :ok", %{conn: conn} do
      post(conn, "/sign-up", @valid_user)

      assert Repo.aggregate(User, :count, :id) == 1

      sign_in_post = post(conn, "/sign-in", @email_sign_in)

      assert json_response(sign_in_post, 200)["message"] == "Signed in successfully."
    end

    @invalid_sing_in %{
      user: %{
        email: "invalid",
        password: "invalid"
      }
    }

    test "unsuccessful sign-in, invalid username/email or password, responds with :unauthorized", %{conn: conn} do
      post(conn, "/sign-up", @valid_user)

      assert Repo.aggregate(User, :count, :id) == 1

      sign_in_post = post(conn, "/sign-in", @invalid_sing_in)

      assert json_response(sign_in_post, 401) == %{
        "error" => "Invalid username/email or password."
      }
    end
  end

  describe "login/2" do

    test "successful login, returns user struct and jwt, responds with :ok", %{conn: conn} do
      post(conn, "/sign-up", @valid_user)

      assert Repo.aggregate(User, :count, :id) == 1

      login_post = post(conn, "/login", @email_sign_in)
      response_body = json_response(login_post, 200)

      assert is_binary(response_body["token"])
      assert String.contains?(response_body["token"], ".")

      user_details = response_body["user"]

      assert user_details["first_name"] == "John"
      assert user_details["last_name"] == "Doe"
      assert user_details["email"] == "johnDoe@example.com"
      assert user_details["username"] == "JohnDoe123"
    end

    test "unsuccessful login, invalid username/email, responds with :unauthorized", %{conn: conn} do
      post(conn, "/sign-up", @valid_user)

      assert Repo.aggregate(User, :count, :id) == 1

      login_post = post(conn, "/login", @invalid_sing_in)

      assert json_response(login_post, 401) == %{
        "error" => "Invalid username/email or password."
      }
    end
  end

  describe "update_user/2" do

    @updated_user %{
      user: %{
        first_name: "UpdatedJohn",
        last_name: "UpdatedDoe",
        email: "updatedJoe@updated.com",
        username: "updatedJoe",
        password: "updatedPass1!"
      }
    }

    test "successfully updated user, responds with :ok", %{conn: conn} do
      create_user = post(conn, "/sign-up", @valid_user)
      assert json_response(create_user, 201)

      login_post = post(conn, "/login", @email_sign_in)
      response_body = json_response(login_post, 200)

      token = response_body["token"]

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      update_put = put(conn, "/update-user", @updated_user)

      update_response_body = json_response(update_put, 200)

      assert update_response_body["user"]["first_name"] == "UpdatedJohn"
      assert update_response_body["user"]["last_name"] == "UpdatedDoe"
      assert update_response_body["user"]["email"] == "updatedJoe@updated.com"
      assert update_response_body["user"]["username"] == "updatedJoe"

    end

    test "unsuccessfully updated user, missing token, responds with :unauthorized", %{conn: conn} do
      update_put = put(conn, "/update-user", @updated_user)

      assert json_response(update_put, 401) == %{
        "error" => "unauthenticated"
      }
    end

    test "unsuccessfully updated user, invalid token, responds with :unauthorized", %{conn: conn} do
      token = "invalidToken"

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      update_put = put(conn, "/update-user", @updated_user)

      assert json_response(update_put, 401) == %{
        "error" => "invalid_token"
      }
    end
  end
end

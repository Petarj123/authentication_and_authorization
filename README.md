# Authentication and Authorization API Endpoints

## Public Endpoints

Sign Up

    Endpoint: POST /sign-up
    Description: Creates a new user account.
    Payload:

    json

    {
      "user": {
        "first_name": "John",
        "last_name": "Doe",
        "email": "johndoe@example.com",
        "username": "JohnDoe123",
        "password": "Password123!"
      }
    }

    Success Response:
        Code: 201 Created
        Content: { "message": "User created successfully" }
    Error Response:
        Code: 422 Unprocessable Entity
        Content: Error messages in the format { "errors": { "field": ["error message"] } }.

Sign In

    Endpoint: POST /sign-in
    Description: Authenticates a user by username or email and password.
    Payload: (username)

    json

    {
      "user": {
        "username": "JohnDoe123",
        "password": "Password123!"
      }
    }

-OR- (email)

    json

    {
      "user": {
        "email": "johndoe@example.com",
        "password": "Password123!"
      }
    }

    Success Response:
        Code: 200 OK
        Content: { "message": "Signed in successfully." }
    Error Response:
        Code: 401 Unauthorized
        Content: { "error": "Invalid credentials" }.

Login

    Endpoint: POST /log-in
    Description: Authenticates a user by username or email and returns a token along with user information.
    Payload: (username)

    json

    {
      "user": {
        "username": "JohnDoe123",
        "password": "Password123!"
      }
    }

-OR- (email)

    json
    
    {
      "user": {
        "email": "johndoe@example.com",
        "password": "Password123!"
      }
    }

Success Response:

    Code: 200 OK
    Content:

    json

    {
      "user": {
        "id": 1,
        "first_name": "John",
        "last_name": "Doe",
        "username": "JohnDoe123",
        "email": "johndoe@example.com",
        "password": "[HASHED]"
      },
      "token": "Bearer eyJhbGciOi..."
    }

Error Response:

    Code: 401 Unauthorized
    Content: { "error": "Invalid credentials" }.
    
## Protected Endpoints

Update User

    Endpoint: PUT /update-user
    Description: Updates the user's information. Requires a Bearer token.
    Headers:
        Authorization: Bearer <token>
    Payload:

    json

{
  "user": {
    "first_name": "Jane",
    "last_name": "Doe",
    "email": "janedoe@example.com",
    "username": "JaneDoe123",
    "password": "NewPassword123!"
  }
}

Success Response:

    Code: 200 OK
    Content:

    json

    {
      "user": {
        "id": 1,
        "first_name": "Jane",
        "last_name": "Doe",
        "username": "JaneDoe123",
        "email": "janedoe@example.com",
        "password": "[HASHED]"
      }
    }

Error Response:

    Code: 422 Unprocessable Entity or 401 Unauthorized
    Content: Error messages or an unauthorized access message.

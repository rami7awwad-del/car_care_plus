# API Integration Guide

## Base URL

http://localhost:8000/api

text

**For Android Emulator:** Use `http://10.0.2.2:8000/api`  
**For Physical Device:** Use your PC's local IP `http://192.168.1.X:8000/api`

---

## Authentication

### 1. Login

**POST** `/auth/login`

**Request:**

```json
{
  "email": "customer@example.com",
  "password": "password123"
}
Success (200):

JSON

{
  "data": {
    "id": 1,
    "name": "John Customer",
    "email": "customer@example.com",
    "phone": "0500000001",
    "token": "1|aBcDeFgHiJkLmNoPqRsTuVwXyZ..."
  },
  "message": "Logged in successfully"
}
Error (401):

JSON

{
  "message": "Invalid credentials"
}
2. Register Customer
POST /auth/register/customer

Request:

JSON

{
  "name": "John Customer",
  "email": "customer@example.com",
  "phone": "0500000001",
  "password": "password123",
  "password_confirmation": "password123"
}
Success (201):

JSON

{
  "data": {
    "user": {
      "id": 2,
      "name": "John Customer",
      "email": "customer@example.com",
      "phone": "0500000001"
    },
    "token": "2|xYzAbC..."
  },
  "message": "Registration successful"
}
Validation Error (422):

JSON

{
  "message": "The email has already been taken.",
  "errors": {
    "email": ["The email has already been taken."]
  }
}
3. Logout
POST /auth/logout

Headers:

text

Authorization: Bearer {token}
Success (200):

JSON

{
  "message": "Logged out successfully"
}
Important Notes
Login accepts email OR phone — backend supports both in the email field
Token: Store securely using flutter_secure_storage
All authenticated requests: Add header Authorization: Bearer {token}
Laravel validation errors: Status 422, check errors object
No OTP for login — only email/password (OTP is for password reset only)
Response Structure
Success:

JSON

{
  "data": {...},
  "message": "..."
}
Error:

JSON

{
  "message": "...",
  "errors": {...}  // only on validation errors (422)
}


those are the api from the backend application
Authentication — Registration
--------------------------------------------------------------------------
*/
Route::prefix('auth')->group(function () {

// Type 1: personal customer — active immediately + token
Route::post('register/customer', [RegisterController::class, 'customer']);

// Type 2: company / workshop — submit a request, pending super-admin approval
Route::post('register/company', [RegisterController::class, 'company']);
Route::post('register/workshop', [RegisterController::class, 'workshop']);

// Login (public) & logout (authenticated)
Route::post('login', LoginController::class);
Route::post('logout', LogoutController::class)->middleware('auth:sanctum');

// Password: forgot / reset via token link (public)
Route::post('forgot-password', [PasswordResetController::class, 'forgot']);
Route::post('reset-password', [PasswordResetController::class, 'reset']);

// Password: forgot / reset via emailed OTP code (public)
Route::post('password/otp/send', [PasswordResetController::class, 'sendResetOtp']);
Route::post('password/otp/reset', [PasswordResetController::class, 'resetWithOtp']);
});
```

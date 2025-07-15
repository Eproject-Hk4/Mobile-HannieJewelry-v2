# Hannie Jewelry API Server

This is a mock API server for the Hannie Jewelry mobile app using JSON Server. It provides all the necessary endpoints to test the app's features, including the phone number OTP authentication system.

## Setup Instructions

### Prerequisites
- Node.js (v12 or higher)
- npm (v6 or higher)

### Installation

1. Navigate to the json-server directory:
```
cd json-server
```

2. Install dependencies:
```
npm install
```

3. Start the server:
```
npm start
```

The server will run on port 3800. For Android emulators, you can access it via `http://10.0.2.2:3800`.

## API Endpoints

### Authentication

- **Send OTP**
  - `POST /auth/send-otp`
  - Request body: `{ "phone": "0123456789" }`
  - Response: `{ "success": true, "verification_id": "abc123", "message": "OTP sent successfully" }`
  - Note: For testing, the OTP is always "123456"

- **Verify OTP (Login)**
  - `POST /auth/verify-otp`
  - Request body: `{ "verification_id": "abc123", "otp": "123456", "phone": "0123456789" }`
  - Response: `{ "success": true, "token": "auth_token", "user": {...}, "message": "Login successful" }`

- **Register with OTP**
  - `POST /auth/register-with-otp`
  - Request body: `{ "verification_id": "abc123", "otp": "123456", "phone": "0123456789", "name": "User Name" }`
  - Response: `{ "success": true, "token": "auth_token", "user": {...}, "message": "Registration successful" }`

- **Get User Profile**
  - `GET /user/profile`
  - Response: User object

- **Logout**
  - `POST /auth/logout`
  - Response: `{ "success": true, "message": "Logged out successfully" }`

### Products

- **Get All Products**
  - `GET /products`

- **Get Product by ID**
  - `GET /products/:id`

- **Get Categories**
  - `GET /categories`

### Cart

- **Get Cart**
  - `GET /cart`

- **Add Item to Cart**
  - `POST /cart/add`
  - Request body: `{ "productId": "p1", "quantity": 1 }`

- **Update Item Quantity**
  - `PUT /cart/update`
  - Request body: `{ "id": "p1", "quantity": 2 }`

- **Remove Item from Cart**
  - `DELETE /cart/item/:id`

- **Clear Cart**
  - `DELETE /cart/clear`

### Orders

- **Get All Orders**
  - `GET /orders`

- **Get Order by ID**
  - `GET /orders/:id`

- **Create Order**
  - `POST /orders`
  - Request body: `{ "items": [...], "totalAmount": 1000000, "paymentMethod": "COD", "shippingAddress": "..." }`

### Notifications

- **Get All Notifications**
  - `GET /notifications`

- **Mark Notification as Read**
  - `PUT /notifications/:id/read`

- **Mark All Notifications as Read**
  - `PUT /notifications/read-all`

- **Delete Notification**
  - `DELETE /notifications/:id`

- **Clear All Notifications**
  - `DELETE /notifications/clear-all`

## Testing the OTP Authentication

For testing purposes, the OTP is always "123456". The authentication flow works as follows:

1. Send OTP to a phone number
2. Receive verification_id in the response
3. Submit the OTP "123456" along with the verification_id and phone number
4. For registration, also include the user's name

## Data Persistence

The server uses the `db.json` file for data storage. Any changes made through API calls will be saved to this file.

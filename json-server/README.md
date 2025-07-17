# JSON Server - API Documentation

## Installation and Running

1. Make sure Node.js and npm are installed
2. Install dependencies:
   ```
   cd json-server
   npm install
   ```
3. Run the server:
   ```
   npm start
   ```

Server will run at http://localhost:3800
For Android emulator, you can access via http://10.0.2.2:3800

## API Endpoints

### Authentication

| Endpoint                      | Method | Description                    | Body                         | Response                                |
|-------------------------------|--------|--------------------------------|-----------------------------|----------------------------------------|
| `/api/auth/request-otp`       | POST   | Request login OTP              | `{ phone }`                 | `{ code, data: verification_id, message }` |
| `/api/auth/request-signup-otp` | POST  | Request signup OTP             | `{ phone }`                 | `{ code, data: verification_id, message }` |
| `/api/auth/login-otp`         | POST   | Login/signup with OTP          | `{ phone, otp }`            | `{ code, data: { token, user, isNewUser }, message }` |
| `/api/auth/logout`            | POST   | Logout                         | - | `{ code, message }` |

### User

| Endpoint              | Method | Description           | Body                       | Response                   |
|-----------------------|--------|-----------------------|----------------------------|----------------------------|
| `/api/user/profile`   | GET    | Get user profile      | - | `{ code, data: user }` |
| `/api/user/profile`   | PUT    | Update profile        | `{ name, email, address }` | `{ code, data: user, message }` |

### Products

| Endpoint                     | Method | Description               | Query Parameters           | Response                       |
|------------------------------|--------|---------------------------|----------------------------|--------------------------------|
| `/api/products`              | GET    | Get product list          | `category`, `featured`, `isNew` | `{ code, data: products }` |
| `/api/products/:id`          | GET    | Get product by ID         | - | `{ code, data: product }` |
| `/api/product-categories`    | GET    | Get product categories    | - | `{ code, data: categories }` |

### Cart

| Endpoint                  | Method | Description                | Body/Params                | Response                    |
|---------------------------|--------|----------------------------|----------------------------|---------------------------- |
| `/api/cart`               | GET    | Get cart                   | - | `{ code, data: cart }` |
| `/api/cart/add`           | POST   | Add product to cart        | `{ productId, quantity, size }` | `{ code, data: cart }` |
| `/api/cart/update`        | PUT    | Update product in cart     | `{ id, quantity, size }` | `{ code, data: cart }` |
| `/api/cart/item/:id`      | DELETE | Remove product from cart   | - | `{ code, data: cart }` |
| `/api/cart/clear`         | DELETE | Clear entire cart          | - | `{ code, data: { id, userId, items: [] }, message }` |

### Orders

| Endpoint              | Method | Description            | Body/Params                                | Response                     |
|-----------------------|--------|------------------------|-------------------------------------------|------------------------------|
| `/api/orders`         | GET    | Get user's orders      | - | `{ code, data: orders }` |
| `/api/orders`         | POST   | Create new order       | `{ items, totalAmount, paymentMethod, shippingAddress }` | `{ code, data: order }` |
| `/api/orders/:id`     | GET    | Get order by ID        | - | `{ code, data: order }` |

### Notifications

| Endpoint                          | Method | Description                | Body/Params | Response                          |
|-----------------------------------|--------|----------------------------|-------------|-----------------------------------|
| `/api/notifications`              | GET    | Get user's notifications   | - | `{ code, data: notifications }` |
| `/api/notifications/:id/read`     | PUT    | Mark notification as read  | - | `{ code, data: notification }` |
| `/api/notifications/read-all`     | PUT    | Mark all as read           | - | `{ code, message }` |

### Addresses

| Endpoint               | Method | Description              | Body/Params                             | Response                      |
|------------------------|--------|--------------------------|----------------------------------------|-------------------------------|
| `/api/addresses`       | GET    | Get user's addresses     | - | `{ code, data: addresses }` |
| `/api/addresses`       | POST   | Add new address          | `{ recipientName, phone, address, isDefault }` | `{ code, data: address }` |
| `/api/addresses/:id`   | PUT    | Update address           | `{ recipientName, phone, address, isDefault }` | `{ code, data: address }` |
| `/api/addresses/:id`   | DELETE | Delete address           | - | `{ code, message }` |

### Rewards and Points

| Endpoint                  | Method | Description                | Body/Params    | Response                           |
|---------------------------|--------|----------------------------|--------------|-----------------------------------|
| `/api/rewards`            | GET    | Get available rewards      | - | `{ code, data: rewards }` |
| `/api/points/history`     | GET    | Get points history         | - | `{ code, data: pointsHistory }` |
| `/api/rewards/redeem`     | POST   | Redeem reward              | `{ rewardId }` | `{ code, data: { user, reward }, message }` |

### News

| Endpoint        | Method | Description             | Query Parameters | Response                    |
|-----------------|--------|-------------------------|-------------------|----------------------------|
| `/api/news`     | GET    | Get news list           | `featured`        | `{ code, data: news }` |
| `/api/news/:id` | GET    | Get news by ID          | -                 | `{ code, data: newsArticle }` |

### Promotions

| Endpoint          | Method | Description                | Query Parameters | Response                        |
|-------------------|--------|----------------------------|-----------------|--------------------------------|
| `/api/promotions` | GET    | Get active promotions     | - | `{ code, data: promotions }` |

### Store Branches

| Endpoint            | Method | Description             | Query Parameters | Response                      |
|---------------------|--------|------------------------|-----------------|------------------------------|
| `/api/branches`     | GET    | Get branch list         | - | `{ code, data: branches }` |
| `/api/branches/:id` | GET    | Get branch by ID        | - | `{ code, data: branch }` |

## Authentication

All endpoints requiring authentication need the Authorization header:
```
Authorization: Bearer [token]
```

Token is returned after successful login at `/api/auth/login-otp`.

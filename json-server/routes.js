const fs = require('fs');
const path = require('path');
const crypto = require('crypto');

// Helper function to read and write to the JSON file
const getDb = () => {
  const dbPath = path.join(__dirname, 'db.json');
  const data = fs.readFileSync(dbPath, 'utf8');
  return JSON.parse(data);
};

const saveDb = (db) => {
  const dbPath = path.join(__dirname, 'db.json');
  fs.writeFileSync(dbPath, JSON.stringify(db, null, 2), 'utf8');
};

// Generate a random token
const generateToken = () => {
  return crypto.randomBytes(32).toString('hex');
};

// Get user from token (simulated)
const getUserFromToken = (req) => {
  // In a real app, we would verify the token here
  // For demo purposes, just return the first user
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return null;
  }
  
  const token = authHeader.substring(7); // Remove 'Bearer ' from header
  const db = getDb();
  
  // For demo purposes, match the token to userId
  if (token.includes('user1')) return db.users.find(u => u.id === 'user1');
  if (token.includes('user2')) return db.users.find(u => u.id === 'user2');
  if (token.includes('user3')) return db.users.find(u => u.id === 'user3');
  
  return db.users[0]; // Default to first user
};

// Custom routes for the JSON server
module.exports = (app) => {
  // Authentication Routes
  
  // Login with OTP flow
  app.post('/api/auth/request-otp', (req, res) => {
    const { phone } = req.body;
    
    if (!phone) {
      return res.status(400).json({ 
        code: 400,
        message: 'Phone number is required' 
      });
    }
    
    const db = getDb();
    const verification_id = generateToken();
    
    // For testing purposes, always use 123456 as the OTP
    const otp = '123456';
    
    // Set expiration time to 5 minutes from now
    const expires_at = new Date(Date.now() + 5 * 60 * 1000).toISOString();
    
    // Check if a verification already exists for this phone
    const existingVerificationIndex = db.verifications.findIndex(v => v.phone === phone);
    
    if (existingVerificationIndex >= 0) {
      // Update existing verification
      db.verifications[existingVerificationIndex] = {
        ...db.verifications[existingVerificationIndex],
        verification_id,
        otp,
        expires_at,
        verified: false
      };
    } else {
      // Create new verification
      db.verifications.push({
        id: `ver${db.verifications.length + 1}`,
        phone,
        verification_id,
        otp,
        expires_at,
        verified: false
      });
    }
    
    saveDb(db);
    
    return res.json({
      code: 200,
      data: verification_id,
      message: 'OTP sent successfully'
    });
  });

  // Request signup OTP - same as login OTP but different endpoint
  app.post('/api/auth/request-signup-otp', (req, res) => {
    const { phone } = req.body;
    
    if (!phone) {
      return res.status(400).json({ 
        code: 400,
        message: 'Phone number is required' 
      });
    }
    
    const db = getDb();
    
    // Check if user exists
    const existingUser = db.users.find(u => u.phone === phone);
    if (existingUser) {
      return res.status(400).json({
        code: 400,
        message: 'User with this phone already exists'
      });
    }
    
    const verification_id = generateToken();
    
    // For testing purposes, always use 123456 as the OTP
    const otp = '123456';
    
    // Set expiration time to 5 minutes from now
    const expires_at = new Date(Date.now() + 5 * 60 * 1000).toISOString();
    
    // Check if a verification already exists for this phone
    const existingVerificationIndex = db.verifications.findIndex(v => v.phone === phone);
    
    if (existingVerificationIndex >= 0) {
      // Update existing verification
      db.verifications[existingVerificationIndex] = {
        ...db.verifications[existingVerificationIndex],
        verification_id,
        otp,
        expires_at,
        verified: false
      };
    } else {
      // Create new verification
      db.verifications.push({
        id: `ver${db.verifications.length + 1}`,
        phone,
        verification_id,
        otp,
        expires_at,
        verified: false
      });
    }
    
    saveDb(db);
    
    return res.json({
      code: 200,
      data: verification_id,
      message: 'OTP sent successfully'
    });
  });
  
  // Verify OTP for login/signup
  app.post('/api/auth/login-otp', (req, res) => {
    const { phone, otp } = req.body;
    
    if (!phone || !otp) {
      return res.status(400).json({
        code: 400, 
        message: 'Missing required fields' 
      });
    }
    
    const db = getDb();
    
    // Find the verification for this phone
    const verification = db.verifications.find(v => v.phone === phone);
    
    if (!verification) {
      return res.status(404).json({ 
        code: 404,
        message: 'No OTP requested for this phone' 
      });
    }
    
    // Check if OTP is correct and not expired
    const now = new Date();
    const expiresAt = new Date(verification.expires_at);
    
    if (verification.otp !== otp) {
      return res.status(400).json({ 
        code: 400,
        message: 'Invalid OTP' 
      });
    }
    
    if (now > expiresAt) {
      return res.status(400).json({ 
        code: 400,
        message: 'OTP expired' 
      });
    }
    
    // Find the user with this phone number
    let user = db.users.find(u => u.phone === phone);
    let isNewUser = false;
    
    // If no user exists, create a new one (for demo purposes)
    if (!user) {
      user = {
        id: `user${db.users.length + 1}`,
        name: `User ${db.users.length + 1}`,
        phone,
        email: '',
        address: '',
        point: 0,
        memberLevel: 'Bronze',
        memberSince: new Date().toISOString().split('T')[0]
      };
      
      db.users.push(user);
      isNewUser = true;
    }
    
    // Mark verification as verified
    verification.verified = true;
    saveDb(db);
    
    // Generate auth token
    const token = `fake-jwt-token-${user.id}`;
    
    return res.json({
      code: 200,
      data: {
        token,
        user,
        isNewUser
      },
      message: isNewUser ? 'Registration successful' : 'Login successful'
    });
  });
  
  // Register new user
  app.post('/api/auth/register', (req, res) => {
    const { name, phone, email, verification_id, otp } = req.body;
    
    if (!name || !phone) {
      return res.status(400).json({ 
        code: 400,
        message: 'Name and phone are required' 
      });
    }
    
    const db = getDb();
    
    // Check if user already exists
    const existingUser = db.users.find(u => u.phone === phone);
    
    if (existingUser) {
      return res.status(400).json({ 
        code: 400,
        message: 'User with this phone already exists' 
      });
    }
    
    // Create new user
    const newUser = {
      id: `user${db.users.length + 1}`,
      name,
      phone,
      email: email || '',
      address: '',
      point: 0,
      memberLevel: 'Bronze',
      memberSince: new Date().toISOString().split('T')[0]
    };
    
    db.users.push(newUser);
    saveDb(db);
    
    // Generate auth token
    const token = `fake-jwt-token-${newUser.id}`;
    
    return res.json({
      code: 200,
      data: {
        token,
        user: newUser
      },
      message: 'Registration successful'
    });
  });
  
  // Get user profile
  app.get('/api/user/profile', (req, res) => {
    const user = getUserFromToken(req);
    
    if (!user) {
      return res.status(401).json({ 
        code: 401,
        message: 'Unauthorized' 
      });
    }
    
    return res.json({
      code: 200,
      data: user
    });
  });
  
  // Update user profile
  app.put('/api/user/profile', (req, res) => {
    const user = getUserFromToken(req);
    
    if (!user) {
      return res.status(401).json({ 
        code: 401,
        message: 'Unauthorized' 
      });
    }
    
    const { name, email, address } = req.body;
    
    const db = getDb();
    const userIndex = db.users.findIndex(u => u.id === user.id);
    
    if (userIndex < 0) {
      return res.status(404).json({ 
        code: 404,
        message: 'User not found' 
      });
    }
    
    // Update user
    const updatedUser = {
      ...db.users[userIndex],
      name: name || db.users[userIndex].name,
      email: email || db.users[userIndex].email,
      address: address || db.users[userIndex].address
    };
    
    db.users[userIndex] = updatedUser;
    saveDb(db);
    
    return res.json({
      code: 200,
      data: updatedUser,
      message: 'Profile updated successfully'
    });
  });
  
  // Logout
  app.post('/api/auth/logout', (req, res) => {
    return res.json({ 
      code: 200,
      message: 'Logged out successfully' 
    });
  });
  
  // Products Routes
  
  // Get all products
  app.get('/api/products', (req, res) => {
    const { category, featured, isNew } = req.query;
    
    const db = getDb();
    let products = db.products;
    
    // Apply filters
    if (category) {
      products = products.filter(p => p.category === category);
    }
    
    if (featured === 'true') {
      products = products.filter(p => p.featured);
    }
    
    if (isNew === 'true') {
      products = products.filter(p => p.isNew);
    }
    
    return res.json({
      code: 200,
      data: products
    });
  });
  
  // Get product by ID
  app.get('/api/products/:id', (req, res) => {
    const { id } = req.params;
    
    const db = getDb();
    const product = db.products.find(p => p.id === id);
    
    if (!product) {
      return res.status(404).json({ 
        code: 404,
        message: 'Product not found' 
      });
    }
    
    return res.json({
      code: 200,
      data: product
    });
  });
  
  // Get product categories
  app.get('/api/product-categories', (req, res) => {
    const db = getDb();
    
    return res.json({
      code: 200,
      data: db.product_categories
    });
  });
  
  // Cart Routes
  
  // Get cart
  app.get('/api/cart', (req, res) => {
    const user = getUserFromToken(req);
    
    if (!user) {
      return res.status(401).json({ 
        code: 401,
        message: 'Unauthorized' 
      });
    }
    
    const db = getDb();
    const cart = db.cart.find(c => c.userId === user.id); 
    
    if (!cart) {
      return res.json({ 
        code: 200,
        data: { id: `cart-${user.id}`, userId: user.id, items: [] }
      });
    }
    
    return res.json({
      code: 200,
      data: cart
    });
  });
  
  // Add item to cart
  app.post('/api/cart/add', (req, res) => {
    const user = getUserFromToken(req);
    
    if (!user) {
      return res.status(401).json({ 
        code: 401,
        message: 'Unauthorized' 
      });
    }
    
    const { productId, quantity, size } = req.body;
    
    if (!productId) {
      return res.status(400).json({ 
        code: 400,
        message: 'Product ID is required' 
      });
    }
    
    const db = getDb();
    const product = db.products.find(p => p.id === productId);
    
    if (!product) {
      return res.status(404).json({ 
        code: 404,
        message: 'Product not found' 
      });
    }
    
    let cart = db.cart.find(c => c.userId === user.id);
    
    if (!cart) {
      cart = { id: `cart-${user.id}`, userId: user.id, items: [] };
      db.cart.push(cart);
    }
    
    // Check if product already in cart
    const existingItemIndex = cart.items.findIndex(item => 
      item.id === productId && (size ? item.size === size : true)
    );
    
    if (existingItemIndex >= 0) {
      // Update quantity
      cart.items[existingItemIndex].quantity += quantity || 1;
    } else {
      // Add new item
      cart.items.push({
        id: product.id,
        name: product.name,
        price: product.price,
        image: product.images[0],
        quantity: quantity || 1,
        size: size || product.sizes[0] || ''
      });
    }
    
    saveDb(db);
    
    return res.json({
      code: 200,
      data: cart
    });
  });
  
  // Update cart item
  app.put('/api/cart/update', (req, res) => {
    const user = getUserFromToken(req);
    
    if (!user) {
      return res.status(401).json({ 
        code: 401,
        message: 'Unauthorized' 
      });
    }
    
    const { id, quantity, size } = req.body;
    
    if (!id) {
      return res.status(400).json({ 
        code: 400,
        message: 'Item ID is required' 
      });
    }
    
    const db = getDb();
    const cart = db.cart.find(c => c.userId === user.id);
    
    if (!cart) {
      return res.status(404).json({ 
        code: 404,
        message: 'Cart not found' 
      });
    }
    
    const itemIndex = cart.items.findIndex(item => item.id === id);
    
    if (itemIndex < 0) {
      return res.status(404).json({ 
        code: 404,
        message: 'Item not found in cart' 
      });
    }
    
    if (quantity !== undefined) {
      cart.items[itemIndex].quantity = quantity;
    }
    
    if (size) {
      cart.items[itemIndex].size = size;
    }
    
    saveDb(db);
    
    return res.json({
      code: 200,
      data: cart
    });
  });
  
  // Remove item from cart
  app.delete('/api/cart/item/:id', (req, res) => {
    const user = getUserFromToken(req);
    
    if (!user) {
      return res.status(401).json({ 
        code: 401,
        message: 'Unauthorized' 
      });
    }
    
    const { id } = req.params;
    
    const db = getDb();
    const cart = db.cart.find(c => c.userId === user.id);
    
    if (!cart) {
      return res.status(404).json({ 
        code: 404,
        message: 'Cart not found' 
      });
    }
    
    cart.items = cart.items.filter(item => item.id !== id);
    
    saveDb(db);
    
    return res.json({
      code: 200,
      data: cart
    });
  });
  
  // Clear cart
  app.delete('/api/cart/clear', (req, res) => {
    const user = getUserFromToken(req);
    
    if (!user) {
      return res.status(401).json({ 
        code: 401,
        message: 'Unauthorized' 
      });
    }
    
    const db = getDb();
    const cart = db.cart.find(c => c.userId === user.id);
    
    if (cart) {
      cart.items = [];
      saveDb(db);
    }
    
    return res.json({
      code: 200,
      data: { id: cart ? cart.id : `cart-${user.id}`, userId: user.id, items: [] },
      message: 'Cart cleared'
    });
  });
  
  // Orders Routes
  
  // Create order
  app.post('/api/orders', (req, res) => {
    const user = getUserFromToken(req);
    
    if (!user) {
      return res.status(401).json({ 
        code: 401,
        message: 'Unauthorized' 
      });
    }
    
    const { items, totalAmount, paymentMethod, shippingAddress } = req.body;
    
    if (!items || !totalAmount || !paymentMethod || !shippingAddress) {
      return res.status(400).json({ 
        code: 400,
        message: 'Missing required fields' 
      });
    }
    
    const db = getDb();
    
    const newOrder = {
      id: `o${db.orders.length + 1}`,
      userId: user.id,
      items,
      totalAmount,
      status: 'pending',
      paymentMethod,
      shippingAddress,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString()
    };
    
    db.orders.push(newOrder);
    
    // Create a notification for the new order
    const newNotification = {
      id: `n${db.notifications.length + 1}`,
      userId: user.id,
      title: 'Order Placed',
      message: `Your order #${newOrder.id} has been placed successfully.`,
      type: 'order',
      read: false,
      createdAt: new Date().toISOString()
    };
    
    db.notifications.push(newNotification);
    
    // Clear the cart
    const cart = db.cart.find(c => c.userId === user.id);
    if (cart) {
      cart.items = [];
    }
    
    // Add points to user
    const pointsToAdd = Math.floor(totalAmount / 100000); // 1 point per 100,000 VND
    const userIndex = db.users.findIndex(u => u.id === user.id);
    if (userIndex >= 0) {
      db.users[userIndex].point += pointsToAdd;
      
      // Add to points history
      db.points_history.push({
        id: `ph${db.points_history.length + 1}`,
        userId: user.id,
        amount: pointsToAdd,
        type: 'earn',
        description: `Purchase: Order #${newOrder.id}`,
        createdAt: new Date().toISOString()
      });
    }
    
    saveDb(db);
    
    return res.json({
      code: 200,
      data: newOrder
    });
  });
  
  // Get user orders
  app.get('/api/orders', (req, res) => {
    const user = getUserFromToken(req);
    
    if (!user) {
      return res.status(401).json({ 
        code: 401,
        message: 'Unauthorized' 
      });
    }
    
    const db = getDb();
    const orders = db.orders.filter(o => o.userId === user.id);
    
    return res.json({
      code: 200,
      data: orders
    });
  });
  
  // Get order by ID
  app.get('/api/orders/:id', (req, res) => {
    const user = getUserFromToken(req);
    
    if (!user) {
      return res.status(401).json({ 
        code: 401,
        message: 'Unauthorized' 
      });
    }
    
    const { id } = req.params;
    
    const db = getDb();
    const order = db.orders.find(o => o.id === id && o.userId === user.id);
    
    if (!order) {
      return res.status(404).json({ 
        code: 404,
        message: 'Order not found' 
      });
    }
    
    return res.json({
      code: 200,
      data: order
    });
  });
  
  // Notifications Routes
  
  // Get user notifications
  app.get('/api/notifications', (req, res) => {
    const user = getUserFromToken(req);
    
    if (!user) {
      return res.status(401).json({ 
        code: 401,
        message: 'Unauthorized' 
      });
    }
    
    const db = getDb();
    const notifications = db.notifications.filter(n => n.userId === user.id);
    
    return res.json({
      code: 200,
      data: notifications
    });
  });
  
  // Mark notification as read
  app.put('/api/notifications/:id/read', (req, res) => {
    const user = getUserFromToken(req);
    
    if (!user) {
      return res.status(401).json({ 
        code: 401,
        message: 'Unauthorized' 
      });
    }
    
    const { id } = req.params;
    
    const db = getDb();
    const notificationIndex = db.notifications.findIndex(
      n => n.id === id && n.userId === user.id
    );
    
    if (notificationIndex < 0) {
      return res.status(404).json({ 
        code: 404,
        message: 'Notification not found' 
      });
    }
    
    db.notifications[notificationIndex].read = true;
    saveDb(db);
    
    return res.json({
      code: 200,
      data: db.notifications[notificationIndex]
    });
  });
  
  // Mark all notifications as read
  app.put('/api/notifications/read-all', (req, res) => {
    const user = getUserFromToken(req);
    
    if (!user) {
      return res.status(401).json({ 
        code: 401,
        message: 'Unauthorized' 
      });
    }
    
    const db = getDb();
    const userNotifications = db.notifications.filter(n => n.userId === user.id);
    
    userNotifications.forEach(notification => {
      notification.read = true;
    });
    
    saveDb(db);
    
    return res.json({
      code: 200,
      message: 'All notifications marked as read'
    });
  });
  
  // Address Routes
  
  // Get user addresses
  app.get('/api/addresses', (req, res) => {
    const user = getUserFromToken(req);
    
    if (!user) {
      return res.status(401).json({ 
        code: 401,
        message: 'Unauthorized' 
      });
    }
    
    const db = getDb();
    const addresses = db.addresses.filter(a => a.userId === user.id);
    
    return res.json({
      code: 200,
      data: addresses
    });
  });
  
  // Add address
  app.post('/api/addresses', (req, res) => {
    const user = getUserFromToken(req);
    
    if (!user) {
      return res.status(401).json({ 
        code: 401,
        message: 'Unauthorized' 
      });
    }
    
    const { recipientName, phone, address, isDefault } = req.body;
    
    if (!recipientName || !phone || !address) {
      return res.status(400).json({ 
        code: 400,
        message: 'Missing required fields' 
      });
    }
    
    const db = getDb();
    
    if (isDefault) {
      // Set all other addresses to non-default
      db.addresses.forEach(addr => {
        if (addr.userId === user.id) {
          addr.isDefault = false;
        }
      });
    }
    
    const newAddress = {
      id: `addr${db.addresses.length + 1}`,
      userId: user.id,
      recipientName,
      phone,
      address,
      isDefault: isDefault || false
    };
    
    db.addresses.push(newAddress);
    saveDb(db);
    
    return res.json({
      code: 200,
      data: newAddress
    });
  });
  
  // Update address
  app.put('/api/addresses/:id', (req, res) => {
    const user = getUserFromToken(req);
    
    if (!user) {
      return res.status(401).json({ 
        code: 401,
        message: 'Unauthorized' 
      });
    }
    
    const { id } = req.params;
    const { recipientName, phone, address, isDefault } = req.body;
    
    const db = getDb();
    const addressIndex = db.addresses.findIndex(
      a => a.id === id && a.userId === user.id
    );
    
    if (addressIndex < 0) {
      return res.status(404).json({ 
        code: 404,
        message: 'Address not found' 
      });
    }
    
    if (isDefault) {
      // Set all other addresses to non-default
      db.addresses.forEach(addr => {
        if (addr.userId === user.id && addr.id !== id) {
          addr.isDefault = false;
        }
      });
    }
    
    const updatedAddress = {
      ...db.addresses[addressIndex],
      recipientName: recipientName || db.addresses[addressIndex].recipientName,
      phone: phone || db.addresses[addressIndex].phone,
      address: address || db.addresses[addressIndex].address,
      isDefault: isDefault !== undefined ? isDefault : db.addresses[addressIndex].isDefault
    };
    
    db.addresses[addressIndex] = updatedAddress;
    saveDb(db);
    
    return res.json({
      code: 200,
      data: updatedAddress
    });
  });
  
  // Delete address
  app.delete('/api/addresses/:id', (req, res) => {
    const user = getUserFromToken(req);
    
    if (!user) {
      return res.status(401).json({ 
        code: 401,
        message: 'Unauthorized' 
      });
    }
    
    const { id } = req.params;
    
    const db = getDb();
    const addressIndex = db.addresses.findIndex(
      a => a.id === id && a.userId === user.id
    );
    
    if (addressIndex < 0) {
      return res.status(404).json({ 
        code: 404,
        message: 'Address not found' 
      });
    }
    
    db.addresses.splice(addressIndex, 1);
    saveDb(db);
    
    return res.json({
      code: 200,
      message: 'Address deleted successfully'
    });
  });
  
  // Rewards and Points Routes
  
  // Get available rewards
  app.get('/api/rewards', (req, res) => {
    const db = getDb();
    const rewards = db.rewards.filter(r => r.active);
    
    return res.json({
      code: 200,
      data: rewards
    });
  });
  
  // Get user points history
  app.get('/api/points/history', (req, res) => {
    const user = getUserFromToken(req);
    
    if (!user) {
      return res.status(401).json({ 
        code: 401,
        message: 'Unauthorized' 
      });
    }
    
    const db = getDb();
    const pointsHistory = db.points_history.filter(p => p.userId === user.id);
    
    return res.json({
      code: 200,
      data: pointsHistory
    });
  });
  
  // Redeem a reward
  app.post('/api/rewards/redeem', (req, res) => {
    const user = getUserFromToken(req);
    
    if (!user) {
      return res.status(401).json({ 
        code: 401,
        message: 'Unauthorized' 
      });
    }
    
    const { rewardId } = req.body;
    
    if (!rewardId) {
      return res.status(400).json({ 
        code: 400,
        message: 'Reward ID is required' 
      });
    }
    
    const db = getDb();
    const reward = db.rewards.find(r => r.id === rewardId && r.active);
    
    if (!reward) {
      return res.status(404).json({ 
        code: 404,
        message: 'Reward not found or not active' 
      });
    }
    
    const userIndex = db.users.findIndex(u => u.id === user.id);
    
    if (userIndex < 0) {
      return res.status(404).json({ 
        code: 404,
        message: 'User not found' 
      });
    }
    
    if (db.users[userIndex].point < reward.points) {
      return res.status(400).json({ 
        code: 400,
        message: 'Not enough points' 
      });
    }
    
    // Deduct points
    db.users[userIndex].point -= reward.points;
    
    // Add to points history
    db.points_history.push({
      id: `ph${db.points_history.length + 1}`,
      userId: user.id,
      amount: reward.points,
      type: 'redeem',
      description: `Redemption: ${reward.title}`,
      createdAt: new Date().toISOString()
    });
    
    saveDb(db);
    
    return res.json({
      code: 200,
      data: {
        user: db.users[userIndex],
        reward
      },
      message: 'Reward redeemed successfully'
    });
  });
  
  // News Routes
  
  // Get news articles
  app.get('/api/news', (req, res) => {
    const { featured } = req.query;
    
    const db = getDb();
    let news = db.news;
    
    if (featured === 'true') {
      news = news.filter(n => n.featured);
    }
    
    return res.json({
      code: 200,
      data: news
    });
  });
  
  // Get news article by ID
  app.get('/api/news/:id', (req, res) => {
    const { id } = req.params;
    
    const db = getDb();
    const newsArticle = db.news.find(n => n.id === id);
    
    if (!newsArticle) {
      return res.status(404).json({ 
        code: 404,
        message: 'News article not found' 
      });
    }
    
    return res.json({
      code: 200,
      data: newsArticle
    });
  });
  
  // Promotions Routes
  
  // Get active promotions
  app.get('/api/promotions', (req, res) => {
    const db = getDb();
    const now = new Date();
    
    const promotions = db.promotions.filter(p => {
      const startDate = new Date(p.startDate);
      const endDate = new Date(p.endDate);
      return p.active && now >= startDate && now <= endDate;
    });
    
    return res.json({
      code: 200,
      data: promotions
    });
  });
  
  // Branches Routes
  
  // Get store branches
  app.get('/api/branches', (req, res) => {
    const db = getDb();
    
    return res.json({
      code: 200,
      data: db.branches
    });
  });
  
  // Get branch by ID
  app.get('/api/branches/:id', (req, res) => {
    const { id } = req.params;
    
    const db = getDb();
    const branch = db.branches.find(b => b.id === id);
    
    if (!branch) {
      return res.status(404).json({ 
        code: 404,
        message: 'Branch not found' 
      });
    }
    
    return res.json({
      code: 200,
      data: branch
    });
  });
};

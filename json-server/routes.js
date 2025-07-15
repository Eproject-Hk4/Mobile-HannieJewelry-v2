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

// Custom routes for the JSON server
module.exports = (app) => {
  // Authentication Routes
  
  // Send OTP
  app.post('/auth/send-otp', (req, res) => {
    const { phone } = req.body;
    
    if (!phone) {
      return res.status(400).json({ success: false, message: 'Phone number is required' });
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
      success: true,
      verification_id,
      message: 'OTP sent successfully'
    });
  });
  
  // Verify OTP for login
  app.post('/auth/verify-otp', (req, res) => {
    const { verification_id, otp, phone } = req.body;
    
    if (!verification_id || !otp || !phone) {
      return res.status(400).json({ success: false, message: 'Missing required fields' });
    }
    
    const db = getDb();
    
    // Find the verification
    const verification = db.verifications.find(
      v => v.verification_id === verification_id && v.phone === phone
    );
    
    if (!verification) {
      return res.status(404).json({ success: false, message: 'Verification not found' });
    }
    
    // Check if OTP is correct and not expired
    const now = new Date();
    const expiresAt = new Date(verification.expires_at);
    
    if (verification.otp !== otp) {
      return res.status(400).json({ success: false, message: 'Invalid OTP' });
    }
    
    if (now > expiresAt) {
      return res.status(400).json({ success: false, message: 'OTP expired' });
    }
    
    // Find the user with this phone number
    const user = db.users.find(u => u.phone === phone);
    
    if (!user) {
      return res.status(404).json({ success: false, message: 'User not found' });
    }
    
    // Mark verification as verified
    verification.verified = true;
    saveDb(db);
    
    // Generate auth token
    const token = generateToken();
    
    return res.json({
      success: true,
      token,
      user,
      message: 'Login successful'
    });
  });
  
  // Register with OTP
  app.post('/auth/register-with-otp', (req, res) => {
    const { verification_id, otp, phone, name } = req.body;
    
    if (!verification_id || !otp || !phone || !name) {
      return res.status(400).json({ success: false, message: 'Missing required fields' });
    }
    
    const db = getDb();
    
    // Find the verification
    const verification = db.verifications.find(
      v => v.verification_id === verification_id && v.phone === phone
    );
    
    if (!verification) {
      return res.status(404).json({ success: false, message: 'Verification not found' });
    }
    
    // Check if OTP is correct and not expired
    const now = new Date();
    const expiresAt = new Date(verification.expires_at);
    
    if (verification.otp !== otp) {
      return res.status(400).json({ success: false, message: 'Invalid OTP' });
    }
    
    if (now > expiresAt) {
      return res.status(400).json({ success: false, message: 'OTP expired' });
    }
    
    // Check if user already exists
    const existingUser = db.users.find(u => u.phone === phone);
    
    if (existingUser) {
      return res.status(400).json({ success: false, message: 'User with this phone number already exists' });
    }
    
    // Create new user
    const newUser = {
      id: `user${db.users.length + 1}`,
      name,
      phone,
      email: '',
      address: ''
    };
    
    db.users.push(newUser);
    
    // Mark verification as verified
    verification.verified = true;
    saveDb(db);
    
    // Generate auth token
    const token = generateToken();
    
    return res.json({
      success: true,
      token,
      user: newUser,
      message: 'Registration successful'
    });
  });
  
  // Get user profile
  app.get('/user/profile', (req, res) => {
    // In a real app, we would verify the auth token here
    // For demo purposes, just return the first user
    const db = getDb();
    const user = db.users[0];
    
    if (!user) {
      return res.status(404).json({ success: false, message: 'User not found' });
    }
    
    return res.json(user);
  });
  
  // Logout
  app.post('/auth/logout', (req, res) => {
    // In a real app, we would invalidate the token here
    return res.json({ success: true, message: 'Logged out successfully' });
  });
  
  // Cart Routes
  
  // Get cart
  app.get('/cart', (req, res) => {
    const db = getDb();
    const cart = db.cart[0]; // For demo, just return the first cart
    
    if (!cart) {
      return res.json({ id: 'cart1', userId: 'user1', items: [] });
    }
    
    return res.json(cart);
  });
  
  // Add item to cart
  app.post('/cart/add', (req, res) => {
    const { productId, quantity } = req.body;
    
    if (!productId) {
      return res.status(400).json({ success: false, message: 'Product ID is required' });
    }
    
    const db = getDb();
    const product = db.products.find(p => p.id === productId);
    
    if (!product) {
      return res.status(404).json({ success: false, message: 'Product not found' });
    }
    
    let cart = db.cart[0]; // For demo, just use the first cart
    
    if (!cart) {
      cart = { id: 'cart1', userId: 'user1', items: [] };
      db.cart.push(cart);
    }
    
    // Check if product already in cart
    const existingItemIndex = cart.items.findIndex(item => item.id === productId);
    
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
        quantity: quantity || 1
      });
    }
    
    saveDb(db);
    
    return res.json({ success: true, cart });
  });
  
  // Update cart item quantity
  app.put('/cart/update', (req, res) => {
    const { id, quantity } = req.body;
    
    if (!id || !quantity) {
      return res.status(400).json({ success: false, message: 'Item ID and quantity are required' });
    }
    
    const db = getDb();
    const cart = db.cart[0]; // For demo, just use the first cart
    
    if (!cart) {
      return res.status(404).json({ success: false, message: 'Cart not found' });
    }
    
    const itemIndex = cart.items.findIndex(item => item.id === id);
    
    if (itemIndex < 0) {
      return res.status(404).json({ success: false, message: 'Item not found in cart' });
    }
    
    cart.items[itemIndex].quantity = quantity;
    
    saveDb(db);
    
    return res.json({ success: true, cart });
  });
  
  // Remove item from cart
  app.delete('/cart/item/:id', (req, res) => {
    const { id } = req.params;
    
    const db = getDb();
    const cart = db.cart[0]; // For demo, just use the first cart
    
    if (!cart) {
      return res.status(404).json({ success: false, message: 'Cart not found' });
    }
    
    cart.items = cart.items.filter(item => item.id !== id);
    
    saveDb(db);
    
    return res.json({ success: true, cart });
  });
  
  // Clear cart
  app.delete('/cart/clear', (req, res) => {
    const db = getDb();
    const cart = db.cart[0]; // For demo, just use the first cart
    
    if (cart) {
      cart.items = [];
      saveDb(db);
    }
    
    return res.json({ success: true, message: 'Cart cleared' });
  });
  
  // Orders Routes
  
  // Create order
  app.post('/orders', (req, res) => {
    const { items, totalAmount, paymentMethod, shippingAddress } = req.body;
    
    if (!items || !totalAmount || !paymentMethod || !shippingAddress) {
      return res.status(400).json({ success: false, message: 'Missing required fields' });
    }
    
    const db = getDb();
    
    const newOrder = {
      id: `o${db.orders.length + 1}`,
      userId: 'user1', // For demo, use the first user
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
      userId: 'user1',
      title: 'Order Placed',
      message: `Your order #${newOrder.id} has been placed successfully.`,
      type: 'order',
      read: false,
      createdAt: new Date().toISOString()
    };
    
    db.notifications.push(newNotification);
    
    // Clear the cart
    const cart = db.cart[0];
    if (cart) {
      cart.items = [];
    }
    
    saveDb(db);
    
    return res.json({ success: true, order: newOrder });
  });
};

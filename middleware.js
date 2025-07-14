module.exports = (req, res, next) => {
  // Thêm header CORS
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept, Authorization');
  res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');

  // Xử lý OPTIONS request
  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }
  
  // Xử lý đăng nhập
  if (req.method === 'POST' && req.path === '/api/auth/login') {
    const { phone, password } = req.body;
    const db = req.app.db;
    const user = db.get('users').find({ phone: phone }).value();
    
    if (user) {
      // Trong môi trường thử nghiệm, chúng ta không kiểm tra mật khẩu
      res.status(200).json({
        success: true,
        user: user,
        token: 'fake-jwt-token-' + user.id
      });
      return;
    } else {
      res.status(401).json({ success: false, message: 'Số điện thoại không tồn tại' });
      return;
    }
  }
  
  // Xử lý đăng ký
  if (req.method === 'POST' && req.path === '/api/auth/register') {
    const { name, phone, password } = req.body;  // Thêm password
    const db = req.app.db;
    const existingUser = db.get('users').find({ phone: phone }).value();
    
    if (existingUser) {
      res.status(400).json({ success: false, message: 'Số điện thoại đã được đăng ký' });
      return;
    }
    
    const newUser = {
      id: Date.now().toString(),
      name: name,
      phone: phone,
      password: password  // Lưu password
    };
    
    console.log('Attempting to write new user:', newUser);

    // Send response before writing to the database
    console.log('Sending response back to client.');
    res.status(201).json({
      success: true,
      user: newUser,
      token: 'fake-jwt-token-' + newUser.id
    });

    // Perform the write operation after sending the response
    try {
      db.get('users').push(newUser).write();
      console.log('Successfully wrote new user.');
    } catch (e) {
      console.error('Error writing to db.json:', e);
    }

    /* Tạm thời bình luận phần tạo giỏ hàng để debug
    db.get('cart').push({
      id: Date.now().toString(),
      user_id: newUser.id,
      items: []
    }).write();
    */
    
    // console.log('Sending response back to client.');
    // res.status(201).json({
    //   success: true,
    //   user: newUser,
    //   token: 'fake-jwt-token-' + newUser.id
    // });
    return;
  }
  
  // Xử lý thêm vào giỏ hàng
  if (req.method === 'POST' && req.path === '/api/cart/add') {
    const { product_id, quantity } = req.body;
    const user_id = req.query.user_id;
    const db = req.app.db;
    
    if (!user_id) {
      res.status(401).json({ success: false, message: 'Unauthorized' });
      return;
    }
    
    const cart = db.get('cart').find({ user_id: user_id }).value();
    const product = db.get('products').find({ id: product_id }).value();
    
    if (!cart || !product) {
      res.status(404).json({ success: false, message: 'Cart or product not found' });
      return;
    }
    
    const existingItemIndex = cart.items.findIndex(item => item.id === product_id);
    
    if (existingItemIndex >= 0) {
      cart.items[existingItemIndex].quantity += quantity || 1;
    } else {
      cart.items.push({
        id: product.id,
        name: product.name,
        price: product.price,
        image: product.image,
        quantity: quantity || 1
      });
    }
    
    db.get('cart').find({ user_id: user_id }).assign({ items: cart.items }).write();
    
    res.status(200).json({
      success: true,
      items: cart.items
    });
    return;
  }
  
  // Xử lý lấy giỏ hàng
  if (req.method === 'GET' && req.path === '/api/cart') {
    const user_id = req.query.user_id;
    const db = req.app.db;
    
    if (!user_id) {
      res.status(401).json({ success: false, message: 'Unauthorized' });
      return;
    }
    
    const cart = db.get('cart').find({ user_id: user_id }).value();
    
    if (!cart) {
      res.status(404).json({ success: false, message: 'Cart not found' });
      return;
    }
    
    res.status(200).json({
      success: true,
      items: cart.items
    });
    return;
  }
  
  next();
};
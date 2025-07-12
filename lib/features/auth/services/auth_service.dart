import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';  // Thêm dòng này

import '../models/user_model.dart';
import 'dart:math'; // Thêm để tạo mã OTP ngẫu nhiên

class AuthService extends ChangeNotifier {
  User? _currentUser;
  bool _isAuthenticated = false;
  String? _verificationId;
  String? _phoneNumber;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  String? get verificationId => _verificationId;
  String? get phoneNumber => _phoneNumber;

  // Khởi tạo và kiểm tra trạng thái đăng nhập từ SharedPreferences
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final userId = prefs.getString('userId');
    final userName = prefs.getString('userName');
    final userPhone = prefs.getString('userPhone');

    if (isLoggedIn && userId != null && userName != null) {
      _currentUser = User(
        id: userId,
        name: userName,
        phone: userPhone ?? '',
      );
      _isAuthenticated = true;
      notifyListeners();
    }
  }

  // Đăng nhập
  Future<bool> login(String phone, String password) async {
    // Trong thực tế, bạn sẽ gọi API để xác thực người dùng
    // Đây là mô phỏng đăng nhập thành công
    _currentUser = User(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Người dùng',
      phone: phone,
    );
    _isAuthenticated = true;

    // Lưu trạng thái đăng nhập vào SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userId', _currentUser!.id);
    await prefs.setString('userName', _currentUser!.name);
    await prefs.setString('userPhone', _currentUser!.phone);

    notifyListeners();
    return true;
  }

  // Gửi mã OTP
  Future<bool> sendOTP(String phone) async {
    // Trong thực tế, bạn sẽ gọi API để gửi OTP qua SMS
    // Đây là mô phỏng gửi OTP thành công
    _phoneNumber = phone;
    
    // Tạo mã OTP ngẫu nhiên 6 chữ số
    final random = Random();
    final otp = List.generate(6, (_) => random.nextInt(10)).join();
    
    // Trong ứng dụng thực tế, mã này sẽ được gửi qua SMS
    // Ở đây chúng ta lưu nó vào SharedPreferences để mô phỏng
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('otp_$phone', otp);
    
    // Lưu ID xác thực (trong thực tế sẽ được cung cấp bởi Firebase hoặc dịch vụ SMS)
    _verificationId = 'verification_${DateTime.now().millisecondsSinceEpoch}';
    
    print('OTP đã được gửi: $otp'); // Chỉ để debug, trong thực tế không nên in OTP
    
    notifyListeners();
    return true;
  }

  // Xác thực OTP
  Future<bool> verifyOTP(String otp) async {
    if (_phoneNumber == null) return false;
    
    // Lấy OTP đã lưu từ SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final savedOTP = prefs.getString('otp_$_phoneNumber');
    
    if (savedOTP == otp) {
      // OTP hợp lệ, đăng nhập người dùng
      _currentUser = User(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Người dùng OTP',
        phone: _phoneNumber!,
      );
      _isAuthenticated = true;

      // Lưu trạng thái đăng nhập
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userId', _currentUser!.id);
      await prefs.setString('userName', _currentUser!.name);
      await prefs.setString('userPhone', _currentUser!.phone);
      
      // Xóa OTP đã sử dụng
      await prefs.remove('otp_$_phoneNumber');
      
      notifyListeners();
      return true;
    }
    
    return false;
  }

  // Đăng xuất
  Future<void> logout() async {
    _currentUser = null;
    _isAuthenticated = false;

    // Xóa trạng thái đăng nhập từ SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('userId');
    await prefs.remove('userName');
    await prefs.remove('userPhone');

    notifyListeners();
  }

  // Đăng ký người dùng mới
  Future<bool> register(String name, String phone, String password) async {
    // Trong thực tế, bạn sẽ gọi API để đăng ký người dùng
    // Đây là mô phỏng đăng ký thành công
    
    // Kiểm tra xem số điện thoại đã được sử dụng chưa
    final prefs = await SharedPreferences.getInstance();
    final existingUserPhone = prefs.getString('registered_$phone');
    
    if (existingUserPhone != null) {
      // Số điện thoại đã được sử dụng
      return false;
    }
    
    // Tạo người dùng mới
    final userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
    
    // Lưu thông tin đăng ký
    await prefs.setString('registered_$phone', userId);
    await prefs.setString('password_$phone', password);
    await prefs.setString('name_$phone', name);
    
    // Đăng nhập người dùng sau khi đăng ký
    _currentUser = User(
      id: userId,
      name: name,
      phone: phone,
    );
    _isAuthenticated = true;

    // Lưu trạng thái đăng nhập
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userId', _currentUser!.id);
    await prefs.setString('userName', _currentUser!.name);
    await prefs.setString('userPhone', _currentUser!.phone);

    notifyListeners();
    return true;
  }
}
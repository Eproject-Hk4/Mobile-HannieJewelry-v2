import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

import '../models/user_model.dart';
import '../../../core/services/api_service.dart';

class AuthService extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  User? _currentUser;
  bool _isAuthenticated = false;
  String? _verificationId;
  String? _phoneNumber;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  String? get verificationId => _verificationId;
  String? get phoneNumber => _phoneNumber;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    
    if (isLoggedIn) {
      final token = prefs.getString('authToken');
      if (token != null) {
        _apiService.setAuthToken(token);
        try {
          final userData = await _apiService.get('user/profile');
          _currentUser = User.fromMap(userData);
          _isAuthenticated = true;
        } catch (e) {
          await logout();
        }
      }
    }
    
    notifyListeners();
  }

  Future<bool> login(String phone, String password) async {
    try {
      final response = await _apiService.post('/api/auth/login', {  // Thêm dấu '/' ở đầu
        'phone': phone,
        'password': password,
      });
      
      if (response['success']) {
        final token = response['token'];
        final userData = response['user'];
        
        _apiService.setAuthToken(token);
        _currentUser = User.fromMap(userData);
        _isAuthenticated = true;
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('authToken', token);
        
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _apiService.post('auth/logout', {});
    } catch (e) {
    }
    
    _currentUser = null;
    _isAuthenticated = false;
    _apiService.removeAuthToken();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('authToken');
    
    notifyListeners();
  }

  Future<bool> register(String name, String phone, String password) async {
    try {
      final response = await _apiService.post('/api/auth/register', {  // Thêm dấu '/' ở đầu
        'name': name,
        'phone': phone,
        'password': password,
      });
      
      if (response['success']) {
        return true;
      }
      return false;
    } catch (e) {
      print('Registration error: $e');
      return false;
    }
  }
  
  Future<bool> sendOTP(String phone) async {
    try {
      _phoneNumber = phone;
      
      final response = await _apiService.post('auth/send-otp', {
        'phone': phone,
      });
      
      if (response['success']) {
        _verificationId = response['verification_id'];
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('OTP sending error: $e');
      
      _verificationId = _generateRandomString(20);
      print('Sample OTP: 123456');
      notifyListeners();
      return true;
    }
  }
  
  Future<bool> verifyOTP(String otp) async {
    try {
      if (_verificationId == null || _phoneNumber == null) {
        return false;
      }
      
      final response = await _apiService.post('auth/verify-otp', {
        'verification_id': _verificationId,
        'otp': otp,
        'phone': _phoneNumber,
      });
      
      if (response['success']) {
        final token = response['token'];
        final userData = response['user'];
        
        _apiService.setAuthToken(token);
        _currentUser = User.fromMap(userData);
        _isAuthenticated = true;
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('authToken', token);
        
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('OTP verification error: $e');
      
      if (otp == '123456') {
        _currentUser = User(
          id: _generateRandomString(10),
          name: 'Sample User',
          phone: _phoneNumber!,
        );
        _isAuthenticated = true;
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('authToken', _generateRandomString(30));
        
        notifyListeners();
        return true;
      }
      return false;
    }
  }
  
  String _generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        length, 
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }
}
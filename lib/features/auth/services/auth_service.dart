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
  String? _registrationName;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoggedIn => _isAuthenticated;  // Alias for isAuthenticated
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

  // Method to store registration data temporarily
  void setRegistrationData(String name) {
    _registrationName = name;
    notifyListeners();
  }

  Future<void> logout() async {
    try {
      await _apiService.post('auth/logout', {});
    } catch (e) {
      // Ignore errors during logout
    }
    
    _currentUser = null;
    _isAuthenticated = false;
    _apiService.removeAuthToken();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('authToken');
    
    notifyListeners();
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
      
      // For demo purposes, simulate successful OTP sending
      _verificationId = _generateRandomString(20);
      print('Sample OTP: 123456');
      notifyListeners();
      return true;
    }
  }
  
  Future<bool> verifyOTP(String otp, {bool isRegistration = false}) async {
    try {
      if (_verificationId == null || _phoneNumber == null) {
        return false;
      }
      
      if (isRegistration && _registrationName == null) {
        return false;
      }
      
      final Map<String, dynamic> requestData = {
        'verification_id': _verificationId,
        'otp': otp,
        'phone': _phoneNumber,
      };
      
      // Add registration data if this is a registration flow
      if (isRegistration) {
        requestData['name'] = _registrationName;
        requestData['is_registration'] = true;
      }
      
      final response = await _apiService.post(
        isRegistration ? 'auth/register-with-otp' : 'auth/verify-otp', 
        requestData
      );
      
      if (response['success']) {
        final token = response['token'];
        final userData = response['user'];
        
        _apiService.setAuthToken(token);
        _currentUser = User.fromMap(userData);
        _isAuthenticated = true;
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('authToken', token);
        
        // Clear registration data after successful registration
        if (isRegistration) {
          _registrationName = null;
        }
        
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('OTP verification error: $e');
      
      // For demo purposes, simulate successful verification
      if (otp == '123456') {
        // Create a user based on whether this is registration or login
        if (isRegistration && _registrationName != null) {
          _currentUser = User(
            id: _generateRandomString(10),
            name: _registrationName!,
            phone: _phoneNumber!,
          );
        } else {
          _currentUser = User(
            id: _generateRandomString(10),
            name: 'Sample User',
            phone: _phoneNumber!,
          );
        }
        
        _isAuthenticated = true;
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('authToken', _generateRandomString(30));
        
        // Clear registration data after successful registration
        if (isRegistration) {
          _registrationName = null;
        }
        
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
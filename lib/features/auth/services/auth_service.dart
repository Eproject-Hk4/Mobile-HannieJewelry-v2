import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:math';
import 'dart:async';

import '../models/user_model.dart';
import '../../../core/services/api_service.dart';

class AuthService extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  
  User? _currentUser;
  bool _isAuthenticated = false;
  String? _verificationId;
  String? _phoneNumber;
  Timer? _otpTimer;
  int _otpRemainingTime = 0;
  
  // OTP expiration time in seconds (5 minutes)
  static const int otpExpirationTime = 300;
  
  // Keys for secure storage
  static const String _tokenKey = 'auth_token';
  static const String _isLoggedInKey = 'is_logged_in';

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoggedIn => _isAuthenticated;  // Alias for isAuthenticated
  String? get verificationId => _verificationId;
  String? get phoneNumber => _phoneNumber;
  int get otpRemainingTime => _otpRemainingTime;
  
  // Setter for phoneNumber
  set phoneNumber(String? value) {
    _phoneNumber = value;
    notifyListeners();
  }

  Future<void> initialize() async {
    try {
      // Read login status from secure storage
      final isLoggedInStr = await _secureStorage.read(key: _isLoggedInKey);
      final isLoggedIn = isLoggedInStr == 'true';
      
      if (isLoggedIn) {
        final token = await _secureStorage.read(key: _tokenKey);
        if (token != null) {
          _apiService.setAuthToken(token);
          try {
            final userData = await _apiService.get('/api/user/profile');
            _currentUser = User.fromMap(userData);
            _isAuthenticated = true;
          } catch (e) {
            await logout();
          }
        }
      }
      
      notifyListeners();
    } catch (e) {
      print('Error initializing auth service: $e');
      // Reset authentication state on error
      _isAuthenticated = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      await _apiService.post('/api/auth/logout', {});
    } catch (e) {
      // Ignore errors during logout
      print('Error during logout API call: $e');
    }
    
    _currentUser = null;
    _isAuthenticated = false;
    _apiService.removeAuthToken();
    
    // Clear secure storage
    try {
      await _secureStorage.delete(key: _tokenKey);
      await _secureStorage.write(key: _isLoggedInKey, value: 'false');
    } catch (e) {
      print('Error clearing secure storage: $e');
    }
    
    notifyListeners();
  }

  Future<bool> sendOTP(String phone) async {
    try {
      _phoneNumber = phone;
      
      // Cancel any existing OTP timer
      _cancelOtpTimer();
      
      // Use the unified endpoint for requesting OTP
      final endpoint = '/api/auth/request-otp';
      
      // API only needs the phone number
      final Map<String, dynamic> requestData = {
        'phone': phone,
      };
      
      print('Sending OTP with endpoint: $endpoint and data: $requestData');
      
      final response = await _apiService.post(endpoint, requestData);
      
      if (response['code'] == 200) {
        _verificationId = response['data'];
        
        // Start OTP expiration timer (5 minutes = 300 seconds)
        _startOtpTimer(otpExpirationTime);
        
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('OTP sending error: $e');
      return false;
    }
  }
  
  Future<bool> verifyOTP(String otp) async {
    try {
      if (_phoneNumber == null) {
        return false;
      }
      
      // Check if OTP has expired
      if (_otpRemainingTime <= 0) {
        print('OTP has expired');
        return false;
      }
      
      // Use the unified endpoint for OTP verification
      final endpoint = '/api/auth/login-otp';
      final requestData = {
        'phone': _phoneNumber,
        'otp': otp,
      };
      
      print('Verifying OTP with endpoint: $endpoint and data: $requestData');
      final response = await _apiService.post(endpoint, requestData);
      
      print('API Response: $response');
      
      if (response['code'] == 200) {
        try {
          // Get token from response
          final token = response['data']['token'];
          final expiresIn = response['data']['expires_in'] ?? 86400000; // Default to 24 hours
          
          // Set authentication state
          _isAuthenticated = true;
          
          // Create a temporary User object with basic information
          _currentUser = User(
            id: '1',
            name: 'User',
            phone: _phoneNumber ?? '',
            email: null,
          );
          
          // Save token to API Service and secure storage
          _apiService.setAuthToken(token);
          await _secureStorage.write(key: _tokenKey, value: token);
          await _secureStorage.write(key: _isLoggedInKey, value: 'true');
          
          // Fetch user profile data after successful authentication
          await _fetchUserProfile();
          
          // Cancel OTP timer as it's been used successfully
          _cancelOtpTimer();
          
          notifyListeners();
          return true;
        } catch (e) {
          print('Error parsing user data: $e');
          return false;
        }
      }
      return false;
    } catch (e) {
      print('OTP verification error: $e');
      return false;
    }
  }
  
  void _startOtpTimer(int seconds) {
    _otpRemainingTime = seconds;
    _otpTimer?.cancel();
    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_otpRemainingTime > 0) {
        _otpRemainingTime--;
        notifyListeners();
      } else {
        _cancelOtpTimer();
      }
    });
  }
  
  void _cancelOtpTimer() {
    _otpTimer?.cancel();
    _otpTimer = null;
    _otpRemainingTime = 0;
    notifyListeners();
  }
  
  Future<bool> _fetchUserProfile() async {
    try {
      final userData = await _apiService.get('/api/user/profile');
      if (userData != null) {
        _currentUser = User.fromMap(userData);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Error fetching user profile: $e');
      return false;
    }
  }
  
  Future<bool> updateProfile(Map<String, dynamic> profileData) async {
    try {
      final response = await _apiService.put('/api/user/profile', profileData);
      
      if (response['code'] == 200) {
        // Update the current user with new data
        if (_currentUser != null) {
          _currentUser = _currentUser!.copyWith(
            name: profileData['name'],
            email: profileData['email'],
            dateOfBirth: profileData['dateOfBirth'],
            gender: profileData['gender'],
          );
          notifyListeners();
        }
        return true;
      }
      return false;
    } catch (e) {
      print('Error updating profile: $e');
      return false;
    }
  }
}
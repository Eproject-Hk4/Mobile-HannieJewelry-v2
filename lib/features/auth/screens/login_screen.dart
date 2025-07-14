import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../home/screens/home_screen.dart';
import '../services/auth_service.dart';
import 'phone_input_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    final authService = Provider.of<AuthService>(context, listen: false);
    final success = await authService.login(
      _phoneController.text,
      _passwordController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  void _navigateToOtpLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PhoneInputScreen()),
    );
  }

  void _navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const Spacer(flex: 1),
              // Logo
              Column(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 120,
                  ),
                  const SizedBox(height: 16),
                  const SizedBox(height: 8),
                  Text(
                    AppStrings.appSlogan,
                    style: AppStyles.bodyText.copyWith(
                      color: AppColors.textLight,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const Spacer(flex: 2),
              // Login form
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 32),
              // Login button
              _isLoading
                  ? const CircularProgressIndicator()
                  : CustomButton(
                text: AppStrings.loginWithPhone,
                onPressed: _login,
              ),
              const SizedBox(height: 16),
              // OTP Login button
              CustomButton(
                text: AppStrings.loginWithOTP,
                onPressed: _navigateToOtpLogin,
                isPrimary: false,
              ),
              const SizedBox(height: 16),
              // Register button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don’t have an account? ',
                    style: AppStyles.bodyTextSmall,
                  ),
                  TextButton(
                    onPressed: _navigateToRegister,
                    child: Text(
                      'Register now',
                      style: AppStyles.bodyTextSmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Skip button
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  );
                },
                child: Text(
                  AppStrings.skip,
                  style: AppStyles.bodyText.copyWith(
                    color: AppColors.textLight,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

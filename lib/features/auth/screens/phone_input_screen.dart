import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../services/auth_service.dart';
import 'otp_verification_screen.dart';

class PhoneInputScreen extends StatefulWidget {
  const PhoneInputScreen({Key? key}) : super(key: key);

  @override
  State<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends State<PhoneInputScreen> {
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendOTP() async {
    // Check for valid phone number
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your phone number')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final authService = Provider.of<AuthService>(context, listen: false);
    final success = await authService.sendOTP(phone);

    setState(() {
      _isLoading = false;
    });

    if (success && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const OTPVerificationScreen(),
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to send OTP. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                AppStrings.loginWithOTP,
                style: AppStyles.heading,
              ),
              const SizedBox(height: 8),
              Text(
                'Enter your phone number to receive a verification code',
                style: AppStyles.bodyTextSmall,
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 32),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : CustomButton(
                text: 'Send verification code',
                onPressed: _sendOTP,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

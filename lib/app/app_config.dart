import 'package:flutter/material.dart';

class AppConfig {
  static const String appName = 'Hannie Jewelry';
  // static const String apiBaseUrl = 'http://10.0.2.2:3800';
  static const String apiBaseUrl = 'https://8080-firebase-haniejewelry-1752584339610.cluster-w5vd22whf5gmav2vgkomwtc4go.cloudworkstations.dev';
  // API Configuration
  static const int connectTimeout = 10000;
  static const int receiveTimeout = 10000;
  
  // App Configuration
  static const bool enableLogging = true;
  static const String appVersion = '1.0.0';
}


// class PhoneAuthScreen extends StatefulWidget {
//   @override
//   _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
// }
//
// class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController otpController = TextEditingController();
//   bool otpSent = false;
//
//   void sendOtp() async {
//     // Call API to send OTP
//     setState(() {
//       otpSent = true;
//     });
//   }
//
//   void verifyOtp() async {
//     // Call API to verify OTP
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Phone Auth')),
//       body: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(
//               controller: phoneController,
//               decoration: InputDecoration(labelText: 'Phone Number'),
//               keyboardType: TextInputType.phone,
//             ),
//             if (otpSent)
//               TextField(
//                 controller: otpController,
//                 decoration: InputDecoration(labelText: 'OTP'),
//                 keyboardType: TextInputType.number,
//               ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: otpSent ? verifyOtp : sendOtp,
//               child: Text(otpSent ? 'Verify OTP' : 'Send OTP'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }